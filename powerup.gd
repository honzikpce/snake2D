extends Area2D

onready var tween = get_node("Tween")
onready var img = get_node("Sprite")

func _ready():
	visible = false
	tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1, Tween.TRANS_EXPO, Tween.EASE_OUT, 0)
	tween.interpolate_property(self, "scale", Vector2(20.0, 20.0), Vector2(1.0, 1.0), 1, Tween.TRANS_EXPO, Tween.EASE_OUT, 0)
	tween.interpolate_property(self, "rotation_degrees", 360, 0, 1, Tween.TRANS_EXPO, Tween.EASE_OUT, 0)
	
	
func spawn():
	visible = true
	tween.start()
	
	
