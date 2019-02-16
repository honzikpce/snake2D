extends Node2D

export (Vector2) var spawn_direction
export (String) var mob_type = "any"

func _ready():
	self.visible = false
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
