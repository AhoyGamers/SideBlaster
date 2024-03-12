extends KinematicBody2D
export (int) var speed = 200
export var canMove:=false
var velocity = Vector2()

func triggerUpgrade():
	$ShapeBuilder.triggerUpgrade()

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	if(canMove && !GlobalVars.paused):
		get_input()
		velocity = move_and_slide(velocity)
		GlobalVars.playerPos = self.global_position

func enableMovement():
	canMove = true
	
func disableMovement():
	canMove = false

#when player gets hit, shrink them and make them faster
func _on_Arena_player_hit():
	scale-=scale*0.13
	speed+=speed*0.1
