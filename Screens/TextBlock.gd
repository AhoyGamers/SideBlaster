extends RichTextLabel
export (String) var shape:="square"
signal unlock(shape)

func _ready():
	if(shape == "square"):
		if(GlobalVars.unlocked_square):
			emit_signal("unlock","Square")
			self.queue_free()
	elif(shape == "kite"):
		if(GlobalVars.unlocked_kite):
			emit_signal("unlock","Kite")
			self.queue_free()
	pass # Replace with function body.

func _on_Kite_block_unlock(shape):
	pass # Replace with function body.
