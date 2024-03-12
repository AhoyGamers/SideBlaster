extends Node


var music = load("res://assets/Chiptronical.ogg")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_music():
	$MusicPlayer.stream = music
	$MusicPlayer.play()

