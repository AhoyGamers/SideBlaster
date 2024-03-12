extends HSlider
var has_focus = false
signal shift_focus_down()
signal shift_focus_up()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func give_focus():
	print("SliderFocusShift: received focus!")
	has_focus = true

func _input(event):
	if(has_focus):
		if(event.is_action_pressed("menu_down")):
			has_focus = false
			emit_signal("shift_focus_down")
		elif(event.is_action_pressed("menu_up")):
			has_focus = false
			emit_signal("shift_focus_up")
