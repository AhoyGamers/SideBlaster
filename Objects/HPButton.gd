extends Node2D
signal clicked
#what item should be spawned when this box is clicked?
export var enabled:= false
var buttonName:="HP"
# Called when the node enters the scene tree for the first time.
func _ready():
	setHoverBoxVisibility(false)

func _on_ClickArea_mouse_entered():
	if(enabled):
		setHoverBoxVisibility(true)

func _on_ClickArea_mouse_exited():
	if(enabled):
		setHoverBoxVisibility(false)

func setHoverBoxVisibility(visibility: bool):
	$HoverBox.visible = visibility

#spawn the specified item at player mouse when UIBox clicked
func _on_ClickArea_input_event(viewport, event, shape_idx):
	if enabled:
		if event is InputEventMouseButton:
			if(event.is_pressed()):
				click()

func click():
	emit_signal("clicked")

#enables functionality of the button
func enable():
	setHoverBoxVisibility(false)
	enabled = true
	
#disable functionality of box and let the player know
func disable():
	setHoverBoxVisibility(true)
	enabled = false

func _on_ShapeBuilder_enable_upgrade_buttons():
	enable()
