extends Control
export (String) var bus:="Master"
export (String) var bottom_slider:=""
export (String) var top_slider:=""
export (int) var min_volume:= -50
export (int) var max_volume:= -6


signal change_focus(next_slider_name) #the name of the next soundLine slider to change to

func _on_HSlider_value_changed(value):
	#-80 is minimumum, -6 is maximum. 74 total
	#ex. Value is 50, thus it should be -80db + (74/x)db 
	#x = max/progress
	var sfx_index= AudioServer.get_bus_index(bus)
	var audio_min = min_volume
	var audio_max = max_volume
	var max_value = $HSlider.max_value
	var progress = float(max_value/value)
	var value_in_db = audio_min - ((audio_min-audio_max)/progress)
	AudioServer.set_bus_volume_db(sfx_index, value_in_db)
	if(bus == "SFX"):
		$SFX.play()
	pass # Replace with function body.
	
func rotated_on_screen():
	$HSlider.grab_focus()
	$HSlider.give_focus()

func _on_HSlider_shift_focus_down():
	print("SoundLine: shifting downwards!")
	$HSlider.release_focus()
	emit_signal("change_focus", bottom_slider)
	pass # Replace with function body.

func _on_HSlider_shift_focus_up():
	print("SoundLine: shifting upwards!")
	$HSlider.release_focus()
	emit_signal("change_focus", top_slider)
	pass # Replace with function body.

func _on_settings_focus_shift(new_slider):
	if(new_slider == bus):
		rotated_on_screen()
