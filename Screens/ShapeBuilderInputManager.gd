extends Node2D
signal _side_fire_key_pressed(side)
# Called when the node enters the scene tree for the first time.
func _input(event):
	if Input.is_action_pressed("fire_up"):
		emit_signal("_side_fire_key_pressed","fire_up")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
