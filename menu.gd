extends Node2D

var gameScene = preload("res://scenes/Game.tscn")
var game
func _ready():
	# fade in
	$Tween.interpolate_property(self, "modulate", Color(0.0,0.0,0.0,1.0), Color(1.0,1.0,1.0,1.0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	$Tween.start()
	
	# instance 
	game = gameScene.instance()
	
	


func _on_level1_pressed():
	game.load_level("01")


func _on_level2_pressed():
	game.load_level("02")


func _on_settings_pressed():
	pass # replace with function body


func _on_exit_pressed():
	get_tree().quit()
