extends Node2D

var cur_direction = Vector2(0, -1)
var cur_postion = Vector2(100,100)

onready var rotate_tween = get_node('Tween')
onready var snakeHead = get_node('Head')


var speed = 150
var rotationTime = 0.15


func _ready():
	pass

func _process(delta):
	
	
	# process input and adjust direction if controls pressed
	if Input.is_action_just_pressed("ui_up") and cur_direction.x != 0 :
		if cur_direction.x == 1 : # moves right
			rotate_tween.interpolate_property(snakeHead, 'rotation_degrees', 90, 0, rotationTime, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		else : # moves to left
			rotate_tween.interpolate_property(snakeHead, "rotation_degrees", 270, 360, rotationTime, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		cur_direction = Vector2(0,-1)
		rotate_tween.start()
	elif Input.is_action_just_pressed("ui_down") and cur_direction.x != 0 :
		if cur_direction.x == 1 : # moves right
			rotate_tween.interpolate_property(snakeHead, 'rotation_degrees', 90, 180, rotationTime, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		else : # moves to left
			rotate_tween.interpolate_property(snakeHead, "rotation_degrees", 270, 180, rotationTime, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		cur_direction = Vector2(0,1)
		rotate_tween.start()
	elif Input.is_action_just_pressed("ui_left") and cur_direction.y != 0 :
		if cur_direction.y == 1 : # moves down
			rotate_tween.interpolate_property(snakeHead, 'rotation_degrees', 180, 270, rotationTime, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		else : # moves up
			rotate_tween.interpolate_property(snakeHead, "rotation_degrees", 360, 270, rotationTime, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		cur_direction = Vector2(-1,0)
		rotate_tween.start()
	elif Input.is_action_just_pressed("ui_right") and cur_direction.y != 0 :
		if cur_direction.y == 1 : # moves down
			rotate_tween.interpolate_property(snakeHead, 'rotation_degrees', 180, 90, rotationTime, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		else : # moves up
			rotate_tween.interpolate_property(snakeHead, "rotation_degrees", 0, 90, rotationTime, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		cur_direction = Vector2(1,0)
		rotate_tween.start()
		
	# move in current direction and rotate if needed
	self.position += cur_direction * speed * delta
	
	
	
	
	
	
	
	
