extends Node2D




func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	if Input.is_key_pressed(KEY_SPACE) and get_tree().paused : 
		get_parent().game_init()
		get_parent().get_tree().paused = false
	if Input.is_key_pressed(KEY_Q):
		get_parent().get_node("Snake").speed += 1
	if Input.is_key_pressed(KEY_W) and get_parent().get_node("Snake").speed > 1 :
		get_parent().get_node("Snake").speed -= 1
		
		