extends Node2D
var cur_screen = "Main"
var menu_direction = "none"

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.connect("joy_connection_changed",self,"_joy_connection_changed")
	unlock_shapes()
	if(!GlobalVars.played_music):
		MusicController.play_music()
		GlobalVars.played_music = true
	$Sprite/Start/StartButton.grab_focus()
	
func unlock_shapes():
	if(GlobalVars.survived_triangle >= GlobalVars.required_square):
		GlobalVars.unlocked_square = true
	if(GlobalVars.survived_square >= GlobalVars.required_kite):
		GlobalVars.unlocked_kite = true

func _joy_connection_changed(id,connected):
	#print("Shapebuilder: joystick " + str(id) + str(connected))
	if(connected == true):
		print("Menu: Controller recently connected!")
		GlobalVars.controller_connected = true
		if($Sprite.rotation == 90):
			$Sprite/Start/StartButton.grab_focus()

func _on_LinkButton_pressed():
	OS.shell_open("https://ahoygamers.tumblr.com/")

func _on_Twitter_pressed():
	OS.shell_open("https://twitter.com/AhoyItsPhil")
	
#play the relevant animation when you want to go to a specific scene
func _input(event):
	if(!$AnimationPlayer.is_playing()):
		if(event.is_action_pressed("menu_left") or menu_direction == "Left"):
			menu_direction = "none"
			if(cur_screen == "Main"):
				$AnimationPlayer.play("MainToCredits")
				cur_screen = "Credits"
			elif(cur_screen == "Settings"):
				$AnimationPlayer.play("SettingsToMain")
				$Sprite/Start/StartButton.grab_focus()
				cur_screen = "Main"
			elif(cur_screen == "Credits"):
				$AnimationPlayer.play("CreditsToSettings")
				cur_screen = "Settings"
		elif(event.is_action_pressed("menu_right") or menu_direction == "Right"):
			menu_direction = "none"
			if(cur_screen == "Main"):
				$AnimationPlayer.play("MainToSettings")
				$Sprite/Start/StartButton.release_focus()
				print("Menu: Changing focus to master slider!")
				$Sprite/Settings/MasterSlider.rotated_on_screen()
				cur_screen = "Settings"
			elif(cur_screen == "Settings"):
				$AnimationPlayer.play("SettingsToCredits")
				cur_screen = "Credits"
			elif(cur_screen == "Credits"):
				$AnimationPlayer.play("CreditsToMain")
				cur_screen = "Main"
				$Sprite/Start/StartButton.grab_focus()


func _on_AnimationPlayer_animation_finished(anim_name):
	#$Sprite/Start/StartButton.grab_focus()
	pass # Replace with function body.

func _on_MenuArrow_clicked(direction):
	menu_direction = direction
	pass # Replace with function body.

func _on_MenuArrow2_clicked(direction):
	menu_direction = direction
	pass # Replace with function body.
