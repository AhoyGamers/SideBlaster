extends Node2D

func _ready():
	$Triangle.grab_focus()
	Input.connect("joy_connection_changed",self,"_joy_connection_changed")

func _joy_connection_changed(id,connected):
	if(connected == true):
		GlobalVars.controller_connected = true
		$Triangle.grab_focus()
