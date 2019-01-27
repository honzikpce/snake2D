extends Area2D

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass


func _on_animplayer_animation_finished(anim_name):
	self.get_parent().remove_child(self)
