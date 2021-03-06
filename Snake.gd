extends Node2D

export (float)var  speed = 150

signal direction_changed(corner)
signal emit_coins(position, number)
signal coin_picked_up(coin)
signal crashed()
signal eat()

var cur_direction = Vector2(0, -1)
var cur_postion = Vector2(0,0)
var direction_changed_bool = false

onready var rotate_tween = get_node('tween')
onready var snakeHead = get_node('head')

#var speed = 150
var rotationTime = 0.1

func reset() :
	#snakeHead.rotation_degrees = 0 # todo
	if rotate_tween.is_active():
		rotate_tween.stop_all()
		
	speed = 150

func _ready():
	$head/Sprite.z_index = 99
	
	$head/animplayer.play("head_animation")
	
func _process(delta):
	# IF SNAKE IS NOT MOVING IT AIN'T DO ANYTHING !!!
	if speed == 0 :
		return
	# process input and adjust direction if controls pressed
	if Input.is_action_just_pressed("ui_up") and cur_direction.x != 0 :
		if cur_direction.x == 1 : # moves right
			rotate_tween.interpolate_property(snakeHead, 'rotation_degrees', 90, 0, rotationTime, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		else : # moves to left
			rotate_tween.interpolate_property(snakeHead, "rotation_degrees", 270, 360, rotationTime, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		cur_direction = Vector2(0,-1)
		rotate_tween.start()
		direction_changed_bool = true
	elif Input.is_action_just_pressed("ui_down") and cur_direction.x != 0 :
		if cur_direction.x == 1 : # moves right
			rotate_tween.interpolate_property(snakeHead, 'rotation_degrees', 90, 180, rotationTime, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		else : # moves to left
			rotate_tween.interpolate_property(snakeHead, "rotation_degrees", 270, 180, rotationTime, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		cur_direction = Vector2(0,1)
		rotate_tween.start()
		direction_changed_bool = true
	elif Input.is_action_just_pressed("ui_left") and cur_direction.y != 0 :
		if cur_direction.y == 1 : # moves down
			rotate_tween.interpolate_property(snakeHead, 'rotation_degrees', 180, 270, rotationTime, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		else : # moves up
			rotate_tween.interpolate_property(snakeHead, "rotation_degrees", 360, 270, rotationTime, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		cur_direction = Vector2(-1,0)
		rotate_tween.start()
		direction_changed_bool = true
	elif Input.is_action_just_pressed("ui_right") and cur_direction.y != 0 :
		if cur_direction.y == 1 : # moves down
			rotate_tween.interpolate_property(snakeHead, 'rotation_degrees', 180, 90, rotationTime, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		else : # moves up
			rotate_tween.interpolate_property(snakeHead, "rotation_degrees", 0, 90, rotationTime, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		cur_direction = Vector2(1,0)
		rotate_tween.start()
		direction_changed_bool = true
		
	
	# emit signal for recording path
	if direction_changed_bool :
		emit_signal('direction_changed', self.position)
		direction_changed_bool = false
	
	# move in current direction and rotate if needed
	self.position += cur_direction * speed * delta
	

func _on_head_area_entered(area) :
	
	# body and walls or traps
	if area.get_collision_layer_bit(1) or area.get_collision_layer_bit(2) :
		emit_signal('crashed')
	# pickable
	if area.get_collision_layer_bit(3) :
		emit_signal('coin_picked_up', area) # if it is coin -todo
		
	# breakable
	if area.get_collision_layer_bit(4) :
		var player = area.get_node("animplayer")
		if area.name.find("barrel",0) == 0 :
			emit_signal("emit_coins", area.position, 5)
		player.play("anim")
		
	# enemy attacking snake
	if area.get_collision_layer_bit(5) :
		var player = area.get_node("../animplayer")
		player.play("hit")
		emit_signal('crashed')
		
	# eating enemy
	if area.get_collision_layer_bit(6) :
		var player = area.get_node("../animplayer")
		emit_signal("emit_coins", area.get_parent().position, 10)
		emit_signal("eat")
		
		
		# disable another collision with mob's attack shape
		area.get_node("../attack/attack_shape").disabled = true
		area.get_parent().remove_child(area.get_node("../attack"))
		area.get_parent().remove_child(area)
		player.play("death")
		
		