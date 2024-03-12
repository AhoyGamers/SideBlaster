extends Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#start the burn material shader animation
func shrink():
	pass

func _on_EnemyBody_burn():
	print("Enemy sprite: shrinking!")
	shrink()
	pass # Replace with function body.
