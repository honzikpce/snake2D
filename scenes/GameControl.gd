extends Node2D




func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	if Input.is_key_pressed(KEY_SPACE) and get_parent().get_node("Snake").speed  == 0 :
		get_parent().game_init()
	if Input.is_key_pressed(KEY_Q):
		get_parent().get_node("Snake").speed += 1
	if Input.is_key_pressed(KEY_W) and get_parent().get_node("Snake").speed > 1 :
		get_parent().get_node("Snake").speed -= 1
	if Input.is_key_pressed(KEY_G) :
		get_parent().grow()	
	if Input.is_key_pressed(KEY_ESCAPE) :
		self.get_parent().emit_signal("menu_clicked")
	
		
		