extends CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready():
	set_shape()
	
#set the texture of the ghost particles based on what shape the player selected
func set_shape():
	if(GlobalVars.shape == "Square"):
		var squareTexture = load("res://assets/square.png")
		self.set_texture(squareTexture)
	elif(GlobalVars.shape == "Triangle"):
		var triangleTexture = load("res://assets/triangle.png")
		self.set_texture(triangleTexture)

#begin emitting particles when player moves
func _on_Player_moving(velocity):
	set_emitting(true)

#stop emitting when the player is not moving
func _on_Player_stopped():
	set_emitting(false)
