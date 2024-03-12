extends Node2D
signal crash(group)
var shape:= GlobalVars.shape
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#remove the ununused player shapes on start
func _ready():
	#print("ShapeObject: Deleting unused shapes!")
	if(shape != "Square"):
		#print("ShapeObject: Deleting square")
		$SquareObject.queue_free()
	if(shape != "Triangle"):
		#print("ShapeObject: Deleting Triangle")
		$TriangleObject.queue_free()
	if(shape != "Kite"):
		#print("ShapeObject: Deleting Triangle")
		$KiteObject.queue_free()
#	if(shape != "Circle"):
#		#print("ShapeObject: Deleting Circle")
#		#$CircleObject.queue_free()
#		pass

func _on_SquareObject_crash(group):
	emit_signal("crash",group)


func _on_TriangleObject_crash(group):
	emit_signal("crash",group)

func _on_KiteObject_crash(group):
	emit_signal("crash",group)
