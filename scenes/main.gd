extends Node2D
var menuScene = preload("res://scenes/menu.tscn")
var gameScene = preload("res://scenes/Game.tscn")

var musicMenu = preload("res://audio/map_01_mix1.ogg")
var musicLev01 = preload("res://audio/snake_adventure.ogg")
var musicLev02 = preload("res://audio/Chinese_2.ogg")

var game = null
var menu = null

func _ready():
	menu = menuScene.instance()
	self.add_child(menu)
	
	# fade in
	$Tween.interpolate_property(menu, "modulate", Color(0.0,0.0,0.0,1.0), Color(1.0,1.0,1.0,1.0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	$Tween.start()

	# instance
	game = gameScene.instance()

	# signals from game screen
	game.connect("menu_clicked", self, "_on_menu_clicked")
	
	# signals from menu screen
	menu.connect("level_01_clicked", self, "_on_level1_pressed")
	menu.connect("level_02_clicked", self, "_on_level2_pressed")	
	menu.connect("settings_clicked", self, "_on_settings_pressed")
	menu.connect("exit_clicked", self, "_on_exit_pressed")
	
	$music.stream = musicMenu
	$music.play()
	
func _on_menu_clicked():
	$music.stop()
	$music.stream = musicMenu
	$music.play()
	
	self.remove_child(game)
	game = gameScene.instance()
	game.connect("menu_clicked", self, "_on_menu_clicked")
	
	self.add_child(menu)
	$Tween.interpolate_property(menu, "modulate", Color(0.0,0.0,0.0,1.0), Color(1.0,1.0,1.0,1.0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)

# old town level
func _on_level1_pressed():
	
	$music.stop()
	$music.stream = musicLev01
	$music.play()
	
	game.load_level("01")
	self.remove_child(menu)
	self.add_child(game)
	$Tween.interpolate_property(game, "modulate", Color(0.0,0.0,0.0,1.0), Color(1.0,1.0,1.0,1.0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)

# chineese level
func _on_level2_pressed():
	$music.stop()
	$music.stream = musicLev02
	$music.play()
	
	game.load_level("02")
	self.remove_child(menu)
	self.add_child(game)
	$Tween.interpolate_property(game, "modulate", Color(0.0,0.0,0.0,1.0), Color(1.0,1.0,1.0,1.0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)

func _on_settings_pressed():
	pass # replace with function body

func _on_exit_pressed():
	get_tree().quit()
