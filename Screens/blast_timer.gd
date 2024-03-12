extends Timer
signal min_cooldown_reached
export (String) var action:="fire_1"
var is_shooting:=false 
var min_cooldown:=0.2
#sent to ShapeBuilder when the minimum cooldown time has occurred

# Called when the node enters the scene tree for the first time.
func _input(event):
		if event.is_action_pressed(action):
			is_shooting = true
		if event.is_action_released(action):
			is_shooting = false
		
func _process(delta):
	if(!GlobalVars.paused):
		if(is_shooting && is_stopped()):
			start_timer()

func start_timer():
	#send the wait time out to the Cooldown_Progress node in each shapeObject
	#so they can start their own timers synced with this one
	GlobalSignals.emit_signal("cooldown_start",action,get_wait_time())
	start()

#decreases the timer length by the specified amount
func _on_ShapeBuilder_decrease_cooldown(amount):
	wait_time-=amount
	if(wait_time <= min_cooldown):
		emit_signal("min_cooldown_reached")

func _on_blast_timer_timeout():
	stop()

func _on_blast_timer2_timeout():
	stop()

func _on_blast_timer3_timeout():
	stop()

func _on_blast_timer4_timeout():
	stop()

func _on_blast_timer5_timeout():
	stop()

func _on_blast_timer6_timeout():
	stop()

func _on_blast_timer7_timeout():
	stop()

func _on_blast_timer8_timeout():
	stop()
