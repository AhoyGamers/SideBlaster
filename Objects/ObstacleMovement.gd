extends KinematicBody2D
export (int) var speed = 200
export var canMove:=true
var velocity = Vector2()

func setVelocity(newVelocity):
	velocity = newVelocity
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	if(canMove && !GlobalVars.paused):
		velocity = move_and_slide(velocity)

func enableMovement():
	canMove = true
	
func disableMovement():
	canMove = false

func _on_Obstacle_hit_with_projectile(hue):
	setHue(hue)

func setHue(amount):
		self.modulate = Color(amount,0.1,0.1)
