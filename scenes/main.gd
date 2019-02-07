extends Node2D
var menuScene = preload("res://scenes/menu.tscn")
var gameScene = preload("res://scenes/Game.tscn")
var game
var menu
func _ready():
	menu = menuScene.instance()
	self.add_child(menu)
	
	# fade in
	$Tween.interpolate_property(menu, "modulate", Color(0.0,0.0,0.0,1.0), Color(1.0,1.0,1.0,1.0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	$Tween.start()

	# instance
	game = gameScene.instance()

	game.connect("menu_clicked", self, "_on_menu_clicked")
	
	menu.connect("level_01_clicked", self, "_on_level1_pressed")
	menu.connect("level_02_clicked", self, "_on_level2_pressed")	
	menu.connect("settings_clicked", self, "_on_settings_pressed")
	menu.connect("exit_clicked", self, "_on_exit_pressed")

func _on_menu_clicked():
	self.remove_child(game)
	game = gameScene.instance()
	game.connect("menu_clicked", self, "_on_menu_clicked")
	
	self.add_child(menu)
	$Tween.interpolate_property(menu, "modulate", Color(0.0,0.0,0.0,1.0), Color(1.0,1.0,1.0,1.0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)


func _on_level1_pressed():
	game.load_level("01")
	self.remove_child(menu)
	self.add_child(game)
	$Tween.interpolate_property(game, "modulate", Color(0.0,0.0,0.0,1.0), Color(1.0,1.0,1.0,1.0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)

func _on_level2_pressed():
	game.load_level("02")
	self.remove_child(menu)
	self.add_child(game)
	$Tween.interpolate_property(game, "modulate", Color(0.0,0.0,0.0,1.0), Color(1.0,1.0,1.0,1.0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)

func _on_settings_pressed():
	pass # replace with function body


func _on_exit_pressed():
	get_tree().quit()
