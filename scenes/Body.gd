extends PathFollow2D

signal crashed()
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Area2D_area_entered(area):
	
	# body and walls or traps
	if area.get_collision_layer_bit(1) or area.get_collision_layer_bit(2) :
		emit_signal('crashed')
	
