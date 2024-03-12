extends Node2D
export (String) var controlType:="Square"
var enabled:=true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_ShapeBuilder_player_started_building():
	if(enabled):
		if(GlobalVars.controller_connected):
			#print("ControlAnimPlayer: Player is using xbox controller!")
			if(controlType=="Xbox"):
				#print("ControlAnimPlayer: fading in xbox Controls!")
				$AnimationPlayer.play("FadeInUI")
				self.visible = true
			else:
				self.visible = false
		else:
			print("ControlAnimPlayer: Player is using keyboard!")
			print("ControlAnimPlayer: ControlType is " + str(controlType) + " while Global Shape is " + str(GlobalVars.shape))
			if(controlType == GlobalVars.shape):
				print("ControlAnimPlayer: fading in " + controlType + " Controls!")
				$AnimationPlayer.play("FadeInUI")
				self.visible = true
			else:
				#hide self if the controlType
				self.visible=false


func _on_ShapeBuilder_ready_for_zoomout():
	if(enabled):
		$AnimationPlayer.play("FadeOutUI")
	pass # Replace with function body.
