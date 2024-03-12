extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.connect("joy_connection_changed",self,"_joy_connection_changed")
	pass # Replace with function body.

func _joy_connection_changed(id,connected):
	#print("Shapebuilder: joystick " + str(id) + str(connected))
	if(connected == true):
		GlobalVars.controller_connected = true
	if(connected == false):
		GlobalVars.controller_connected = false

func getObjectsInGroup(groupName: String, scene: Node2D) -> Array:
	var sceneChildren:= scene.get_children()
	var groupObjects:= []
	for child in sceneChildren:
		if child.is_in_group(groupName):
			groupObjects.append(child)
	return groupObjects

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
