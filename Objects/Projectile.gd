extends Node2D
export var speed = 2000
var trail = null #the node of the particles behind the sprite that make the trail

# Called when the node enters the scene tree for the first time.
func _ready():
	trail = get_node("Sprite/Particles")
	pass # Replace with function body.

func _physics_process(delta):
	position += transform.x * speed * delta
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	if(area.is_in_group("Enemy") || area.is_in_group("DeathPlane") || area.is_in_group("Boundry")):
		queue_free()
	pass # Replace with function body.

#triggered every 1 second
#every second, make the particles just a big longer
func _on_Timer_timeout():
	if(trail.lifetime < 0.3):
		trail.lifetime +=0.1
		$Timer.wait_time += 0.1
	pass # Replace with function body.
