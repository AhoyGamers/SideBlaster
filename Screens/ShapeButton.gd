extends TextureButton
export (String) var shape:="Square"

export var enabled:=false

func _on_pressed():
	if(enabled):
		GlobalVars.shape = shape
		print("ShapeButton: global shape: " + GlobalVars.shape)
		get_tree().change_scene("res://Screens/Arena.tscn")

func _on_focus_exited():
	hide()

func _on_focus_entered():
	if(enabled):
		show()

func _on_mouse_entered():
	if(enabled):
		show()

func _on_mouse_exited():
	hide()

func show():
	modulate = Color(1,1,1,1)
	
func hide():
	modulate = Color(0.5,0.5,0.5,1)

func _on_block_unlock(Unlocked_shape):
	print("ShapeButton: Unlocking " + str(Unlocked_shape))
	if(shape == Unlocked_shape):
		print("I am unlocked")
		enabled = true
		visible = true
	pass # Replace with function body.
