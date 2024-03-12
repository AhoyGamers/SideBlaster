extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$RestartButton.grab_focus()
	pass # Replace with function body.

func _on_MenuButton_pressed():
	get_tree().change_scene("res://Screens/Menu.tscn")


func _on_RestartButton_pressed():
	get_tree().change_scene("res://Screens/Arena.tscn")
	pass # Replace with function body.
