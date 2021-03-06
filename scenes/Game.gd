extends Node2D

signal menu_clicked

onready var coinCounterText = get_node("UI/CoinCounter/Label")
onready var lifeCounterText = get_node("UI/LifeCounter/Label")

var SNAKE_PARTS_DISTANCE = 20 # 25
var SNAKE_START_LENGTH = 3
var SNAKE_SPAWN_POINT
var SNAKE_SPAWN_DIR
var SNAKE_SPAWN_ROTATION

var coins_picked_up = 0
var lives = 3
var isSnakeCrashed = false

var snake = null
var snakeScene = preload("res://scenes/Snake.tscn")

var trail = null

var tailScene = preload("res://scenes/Tail.tscn")
var bodyScene = preload("res://scenes/Body.tscn")
var coinScene = preload("res://scenes/Coin.tscn")

# should be loaded in level loading and only the ones to be used. But whatever for now...
var enemyScenes = {	"knight" : preload("res://scenes/knight.tscn"), 
					"sumo" : preload("res://scenes/sumo.tscn")}

var originalScale = Vector2(1.0, 1.0)

var DEBUG = false

var current_level

func _ready():
	
	game_init()
	game_reset()
	
	snake.connect("coin_picked_up", self, "_on_Snake_coin_picked_up")
	snake.connect("crashed", self, "_on_Snake_crashed")
	snake.connect("direction_changed", self, "_on_Snake_direction_changed")
	snake.connect("eat", self, "_on_Snake_eat")
	snake.connect("emit_coins", self, "_on_Snake_emit_coins")

# reset all stuff to original values
func game_reset():
	# set variables
	isSnakeCrashed = false
	coins_picked_up = 0 # reset coins
	
	# clean up enemies
	while current_level.get_node("enemies/spawned").get_child_count() :
		current_level.get_node("enemies/spawned").remove_child(current_level.get_node("enemies/spawned").get_children().pop_back())
	
	# empty body parts and tail (need to remove them from the last one! )
	while trail.get_child_count() :
		trail.remove_child(trail.get_children().pop_back())
	
	# empty trail
	trail.curve.clear_points()
	
				
	# init game
	snake.position = SNAKE_SPAWN_POINT
	snake.cur_direction = SNAKE_SPAWN_DIR
	snake.get_node("head").rotation_degrees = SNAKE_SPAWN_ROTATION
	
	snake.reset()
	
	trail.curve.add_point(Vector2(snake.position.x  - SNAKE_SPAWN_DIR.x * ((SNAKE_START_LENGTH + 2) * SNAKE_PARTS_DISTANCE), snake.position.y - SNAKE_SPAWN_DIR.y * ((SNAKE_START_LENGTH + 2) * SNAKE_PARTS_DISTANCE))) # this is the beginning of a trail
	trail.curve.add_point(snake.position) # adding the location of the head which is to be updated

	# add one body part so we can add others "bellow" it
	
	grow()
	# add the tail to the end
	var tail  = tailScene.instance()
	var tail_anim = tail.get_node("Area2D/animplayer")
	tail_anim.play("tail_animation")
	trail.add_child(tail)
	#tail is supposed to be under body parts but under background objects
	tail.z_index = 2
 
	# grow the snake 
	for i in range(1,SNAKE_START_LENGTH) :
		grow()	
	
	# spawn first enemy
	spawn_enemy()


func _process(delta):
	
	# update UI labels with current values
	coinCounterText.text = str(coins_picked_up)
	lifeCounterText.text = str(lives)
	
	# set end point of the curve to the new position of the head
	trail.curve.set_point_position(trail.curve.get_point_count()-1, Vector2(snake.position.x, snake.position.y))
		
	# cycle from first body part to tail and set their offsets
	for i in range(0, trail.get_child_count()) :
		trail.get_child(i).offset = trail.curve.get_baked_length() - SNAKE_PARTS_DISTANCE * (i + 1)	
		# snake waves
		trail.get_child(i).v_offset = sin(trail.get_child(i).offset / 25.0) * 3

func _on_Snake_direction_changed(corner):
	trail.curve.set_point_position(trail.curve.get_point_count()-1, corner) # change last point to last direction change point
	
	# add tangent to the corner point to make it smooth
	var intan = Vector2()
	var outtan = snake.cur_direction * 15 # this is a turn radius
	
	trail.curve.add_point(snake.position, intan, outtan) # add the head position
	
func grow():
	var newPart = bodyScene.instance()
	newPart.connect("crashed", self, "_on_Snake_crashed")
	newPart.z_index = 90 - trail.get_child_count()
	
	# disable colisions on first body parts to not colide with head while turning
	if trail.get_child_count() < 2 :
		newPart.get_node("Area2D").collision_layer = 0
	
	if trail.get_child_count() :
		trail.add_child_below_node(trail.get_children()[trail.get_child_count()-2], newPart)
	else :		
		trail.add_child(newPart)
		
# init the game for the first time
func game_init():
	randomize()
	# add snake to scene
	snake = snakeScene.instance()
	snake.name = "Snake"
	self.add_child(snake)
	
	# add a trail for other parts of a snake
	trail = Path2D.new()
	self.add_child(trail)
	
func _on_Snake_crashed():
	if isSnakeCrashed :
		return
	
	isSnakeCrashed = true
	
	lives -= 1
	if lives < 0 :
		lives = 0
	# animate head while crashing
	for i in range (0,6,2):
		$Tween.interpolate_property(snake, "modulate", Color(1.0,1.0,1.0,1.0), Color(1.0,0.4,1.0,0.4), 0.1, Tween.TRANS_LINEAR, 0, i * 0.1)
		$Tween.interpolate_property(snake, "modulate", Color(1.0,0.4,0.4,1.0), Color(1.0,1.0,1.0,1.0), 0.1, Tween.TRANS_LINEAR, 0, (i + 1) * 0.1)
		
	$Tween.interpolate_property(snake, "speed", 150.0, 0.0, 0.1, Tween.TRANS_QUINT, 0, 0)
	
	$Tween.start()


func _on_Snake_emit_coins(position, number):
	for i in range(number) :
		var newCoin = coinScene.instance()
		newCoin.get_node("animplayer").play("rotation")
		# move each coin evenly around the spawn point
		$Tween.interpolate_property(newCoin, "position", position, position + Vector2(30,0).rotated((2 * PI / number) * i), 0.3, Tween.TRANS_LINEAR, 0, 0)
		# fade in tween
		$Tween.interpolate_property(newCoin, "modulate", Color(1.0,1.0,1.0,0.0), Color(1.0,1.0,1.0,0.8), 0.4, Tween.TRANS_LINEAR, 0, 0)
		self.add_child(newCoin)
	$Tween.start()

func _on_Snake_coin_picked_up(coin):
		# move coin towards the coin counter
		$Tween.interpolate_property(coin, "position", coin.position, $UI/CoinCounter.position, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, 0.2)
		# fade in tween
		$Tween.interpolate_property(coin, "modulate", Color(1.0,1.0,1.0,0.8), Color(1.0,1.0,1.0,0.0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.2)
	# todo : clean up... remove the coin instances from game

func _on_Tween_tween_completed(object, key):
	if str(key).find("position", 0) > 0 and object.modulate.a < 0.1 :
		coins_picked_up += 1
		if coins_picked_up % 2 == 0 :
			grow()
		self.remove_child(object)
		
func load_level(name):
	var level_file_name = "res://scenes/level" + name + ".tscn"
	var level_scene = load(level_file_name)
	var level = level_scene.instance()
	
	# save refference to global var
	current_level = level
	
	# level is in a background
	level.z_index = -1
	self.add_child(level)
	
	# load snake spawn point
	SNAKE_SPAWN_POINT = level.get_node("spawn_point").position
	SNAKE_SPAWN_DIR = level.get_node("spawn_point").spawn_direction
	SNAKE_SPAWN_ROTATION = level.get_node("spawn_point").rotation_degrees
	
func spawn_enemy() :
	if not current_level : 
		if DEBUG :
			print("No level loaded and trying to spawn enemy!!!")
		return # no level loaded !
	
	# select random spawn point
	var spawns = current_level.get_node("enemies/spawns")	
	var selectedSpawn = spawns.get_child((randi() % spawns.get_child_count()))

	var enemy
	if enemyScenes.has(selectedSpawn.mob_type) :
		enemy = enemyScenes[selectedSpawn.mob_type].instance()
	
	# if enemy still not loaded, pick random one
	if not enemy :
		enemy = enemyScenes.values()[randi() % enemyScenes.keys().size()].instance()
		
	enemy.position = selectedSpawn.position
	enemy.rotation_degrees = selectedSpawn.rotation_degrees
	enemy.get_node("animplayer").play("spawn")
	current_level.get_node("enemies/spawned").add_child(enemy)
	
func _on_Snake_eat():
	
	# when enemy is eaten, spawn a new one
	spawn_enemy()
	
	# scaling body parts to animate eating enemies
	if trail.get_child_count() > 2 :
		for i in range(0, 2) :
			$Tween.interpolate_property(trail.get_child(i), "scale", originalScale, originalScale + Vector2(i * 0.4, i * 0.4), 0.3,Tween.TRANS_LINEAR, 0, i * 0.1)
			$Tween.interpolate_property(trail.get_child(i), "scale", originalScale + Vector2(i * 0.4, i * 0.4), originalScale, 0.3,Tween.TRANS_LINEAR, 0, i * 0.1 + 0.3)
			
			$Tween.interpolate_property(trail.get_child(i+3), "scale", originalScale, originalScale + Vector2((2 - i) * 0.4, (2 - i) * 0.4), 0.3,Tween.TRANS_LINEAR, 0, i * 0.1)
			$Tween.interpolate_property(trail.get_child(i+3), "scale", originalScale + Vector2((2 - i) * 0.4, (2 - i) * 0.4), originalScale, 0.3,Tween.TRANS_LINEAR, 0, i * 0.1 + 0.3)

