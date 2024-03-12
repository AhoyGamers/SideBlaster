extends KinematicBody2D

export (int) var speed = 999

#Can the player move?
export var canMove:= true

var velocity = Vector2()

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	if(canMove):
		get_input()
		velocity = move_and_slide(velocity)
		
func toggleMovement():
	canMove = !canMove
