extends Node2D

func _input(event):
	if(event.is_action_pressed("pause")):
		togglePause()

func togglePause():
	if(get_tree().paused):
		GlobalVars.paused = false
		get_tree().paused = false
		visible = false
	elif(!GlobalVars.paused): 
		#globalVars paused usually only apply when shapebuilder is active
		#Because of the camera zoom in/out don't allow pausing while
		#shapebilder is active
		if(GlobalVars.controller_connected):
			$ResumeButton.grab_focus() #default to selecting the resume button when paused
		GlobalVars.paused = true
		get_tree().paused = true
		visible = true

func _on_MenuButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Screens/Menu.tscn")

func _on_ResumeButton_pressed():
	togglePause()
	pass # Replace with function body.
