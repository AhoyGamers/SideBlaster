extends KinematicBody2D
export (int) var speed = 200
export var canMove:=true
var velocity = Vector2()

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
	if(canMove && GlobalVars.paused && GlobalVars.controller_connected):#&& GlobalVars.controller_connected):
		get_input()
		velocity = move_and_slide(velocity)
		GlobalVars.controllerMenuPostion = self.global_position

func enable():
	canMove = true
	
func disableMovement():
	canMove = false
