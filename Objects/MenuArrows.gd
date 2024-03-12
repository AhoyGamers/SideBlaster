extends Node2D
export var direction:="Left"
signal clicked(direction)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("bob")

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
			if(event.is_pressed()):
				emit_signal("clicked",direction)
	pass # Replace with function body.
