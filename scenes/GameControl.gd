extends Node2D




func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	if Input.is_key_pressed(KEY_SPACE) and get_tree().paused : 
		get_parent().game_init()
		get_tree().paused = false
		get_parent().get_tree().paused = false