extends TextureProgress
export (String) var assigned_key:="fire_1"
var is_updating:= false
var totalTime = 1
var enabled:=false
# Called when the node enters the scene tree for the first time.
func _ready():
	#connect global signal to self so the blaster can tell US it has been fired
	GlobalSignals.connect("cooldown_start", self, "on_cooldown_start")
	GlobalSignals.connect("blaster_placed", self, "on_blaster_placed")
	
	pass # Replace with function body.

func on_blaster_placed(blaster_key):
	if(blaster_key == assigned_key):
		enabled = true

#the global signal triggered when a blaster has fired
func on_cooldown_start(key,time):
	if(key == assigned_key):
		totalTime = time
		$Timer.set_wait_time(time)
		$Timer.start()
		is_updating = true

func _process(delta):
	if(is_updating && !GlobalVars.paused && enabled):
		#reverse fill the progress bar with the time
		if($Timer.time_left > 0.0):
			var progress = ($Timer.time_left / totalTime) * 100
			value = progress


func _on_Timer_timeout():
	is_updating = false
	value = 0
	$Timer.stop()
