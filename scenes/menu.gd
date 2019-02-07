extends Node2D

signal menu_clicked
signal level_01_clicked
signal level_02_clicked
signal settings_clicked
signal exit_clicked

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_level1_pressed():
	emit_signal("level_01_clicked")


func _on_level2_pressed():
	emit_signal("level_02_clicked")


func _on_settings_pressed():
	emit_signal("settings_clicked")


func _on_exit_pressed():
	emit_signal("exit_clicked")
