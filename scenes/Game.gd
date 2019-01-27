extends Node2D

onready var trail = get_node('SnakeTrail')
onready var snake = get_node('Snake')

onready var title_tween = get_node('title_tween')
onready var label = get_node("Label")
onready var test_powerup = get_node("powerup")
onready var coinCounterText = get_node("UI/CoinCounter/Label")
onready var lifeCounterText = get_node("UI/LifeCounter/Label")

var SNAKE_PARTS_DISTANCE = 25
var SNAKE_START_LENGTH = 3
var SNAKE_SPAWN_POINT
var SNAKE_SPAWN_DIR = Vector2(0, -1)

var coins_picked_up = 0
var lives = 3


var tailScene = preload("res://scenes/Tail.tscn")
var bodyScene = preload("res://scenes/Body.tscn")
var coinScene = preload("res://scenes/Coin.tscn")

var DEBUG = false


func _ready():
	SNAKE_SPAWN_POINT = snake.position
	
		
	game_init()

func _process(delta):
	coinCounterText.text = str(coins_picked_up)
	lifeCounterText.text = str(lives)
	
	# set end point of the curve to the new position of the head
	trail.curve.set_point_position(trail.curve.get_point_count()-1, Vector2(snake.position.x, snake.position.y))
		
	# cycle from first body part to tail and set their offsets
	for i in range(0, trail.get_child_count()) :
		trail.get_child(i).offset = trail.curve.get_baked_length() - SNAKE_PARTS_DISTANCE * (i + 1)	

func _on_Snake_direction_changed(corner):
	trail.curve.set_point_position(trail.curve.get_point_count()-1, corner) # change last point to last direction change point
	trail.curve.add_point(snake.position) # add the head position

func grow():
	var newPart = bodyScene.instance()
	newPart.z_index = 90 - trail.get_child_count()
	
	if trail.get_child_count() < 15 :
		newPart.get_node("Area2D").collision_layer = 0
	
	
	if trail.get_child_count() :
		trail.add_child_below_node(trail.get_children()[trail.get_child_count()-2], newPart)
	else :
		trail.add_child(newPart)
	
		

func game_init():
	coins_picked_up = 0 # reset coins
	
	# empty body parts and tail (need to remove them from the last one! )
	while trail.get_child_count() :
		trail.remove_child(trail.get_children().pop_back())
	
	# empty trail
	trail.curve.clear_points()
	
	label.visible = false
				
	# init game
	snake.position = SNAKE_SPAWN_POINT
	snake.cur_direction = SNAKE_SPAWN_DIR
	
	snake.reset()
	
	trail.curve.add_point(Vector2(snake.position.x, snake.position.y - SNAKE_SPAWN_DIR.y * ((SNAKE_START_LENGTH + 2) * SNAKE_PARTS_DISTANCE))) # this is the beginning of a trail
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
	

	
	# knight test
	$knight/animplayer.play("idle")
	

func _on_Snake_crashed():
	label.visible = true
	get_tree().paused = true
	
	lives -= 1
	if lives < 0 :
		lives = 0
		
	
	title_tween.interpolate_property(label, 'rect_position', Vector2(label.rect_position.x, -200.0), label.rect_position, 1.0, Tween.TRANS_ELASTIC, Tween.EASE_OUT, 0)
	title_tween.start()
	
	
	

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
