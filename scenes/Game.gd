extends Node2D

onready var trail = get_node('SnakeTrail')
onready var snake = get_node('Snake')
onready var title_tween = get_node('title_tween')
onready var label = get_node("Label")
onready var test_powerup = get_node("powerup")

var SNAKE_PARTS_DISTANCE = 18
var SNAKE_START_LENGTH = 10
var SNAKE_SPAWN_POINT
var SNAKE_SPAWN_DIR = Vector2(0, -1)

var tailScene = preload("res://scenes/Tail.tscn")
var bodyScene = preload("res://scenes/Body.tscn")

var DEBUG = false

func _ready():
	SNAKE_SPAWN_POINT = snake.position
	
		
	game_init()

func _process(delta):
	
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
	newPart.z_index = 5 + trail.get_child_count()
	trail.add_child(newPart)

func game_init():
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
	print("breakpoint")
	
	# grow the snake 
	for i in range(1,SNAKE_START_LENGTH) :
		grow()

# add the tail to the end
	var tail  = tailScene.instance()
	trail.add_child(tail)
	tail.z_index = 99

func _on_Snake_crashed():
	label.visible = true
	get_tree().paused = true
	
	title_tween.interpolate_property(label, 'rect_position', Vector2(label.rect_position.x, -200.0), label.rect_position, 1.0, Tween.TRANS_ELASTIC, Tween.EASE_OUT, 0)
	title_tween.start()
	
	print("crashed!")
	print(snake.position)
	print(trail.get_children()[0].position)
	
	#test_powerup.spawn()
	