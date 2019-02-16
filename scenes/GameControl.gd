extends Node2D


func _ready():
	pass

func _process(delta):
	if Input.is_key_pressed(KEY_SPACE) and get_parent().isSnakeCrashed :
		get_parent().game_reset()
	if Input.is_key_pressed(KEY_Q):
		get_parent().get_node("Snake").speed += 1
	if Input.is_key_pressed(KEY_W) and get_parent().get_node("Snake").speed > 1 :
		get_parent().get_node("Snake").speed -= 1
	if Input.is_key_pressed(KEY_G) :
		get_parent().grow()	
	
		
	if Input.is_key_pressed(KEY_ESCAPE) :
		self.get_parent().emit_signal("menu_clicked")
	