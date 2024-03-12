extends KinematicBody2D
signal shot()
signal crashedIntoPlayer()
signal outOfBounds()
signal burn
export (int) var speed = 100
export var canMove:=true
var velocity = Vector2()
var crashed:=false
export var followsPlayer:=false

# Called when the node enters the scene tree for the first time.
func _ready():
	setVelocity(Vector2(0,0))

func _physics_process(delta):
	if(canMove && GlobalVars.paused == false):
		velocity = global_position.direction_to(GlobalVars.playerPos) * speed
		velocity = move_and_slide(velocity)

func enableMovement():
	canMove = true
	
func disableMovement():
	canMove = false
	
func setVelocity(received: Vector2):
	velocity = received

func _on_Area2D_area_entered(area):
	if(area.is_in_group("Player")):
		emit_signal("crashedIntoPlayer")
		crashed=true
	elif(area.is_in_group("Projectile")):
		emit_signal("shot")
	elif(area.is_in_group("DeathPlane")):
		emit_signal("outOfBounds")
	else:
		crashed=true

func _on_EnemySquare_crashedIntoPlayer(amount):
	setHue(amount)

func setHue(amount):
		self.modulate = Color(amount,0.1,0.1)

#turn on the burning fade shader for the sprite
func burn():
	#stop emitting particles when enemy dies
	$Particles.emitting = false
	#stop collision for square
	$Area2D.queue_free()
	emit_signal("burn")
	pass # Replace with function body.
