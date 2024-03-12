extends ParallaxBackground
 
var direction: Vector2 = Vector2(0, 0);
var rng = RandomNumberGenerator.new()
var enabled:=false

func _ready():
	randomize_direction()

func randomize_direction():
	var x_direction
	var y_direction
	if(coinFlip()):
		x_direction = generateRanNum(-25,-13)
	else:
		x_direction = generateRanNum(13,25)

	if(coinFlip()):
		y_direction = generateRanNum(-25,-13)
	else:
		y_direction = generateRanNum(13,25)

	direction = Vector2(x_direction,y_direction)

func generateRanNum(minimum,maximum)->float:
	rng.randomize()
	return rng.randf_range(minimum,maximum)

func coinFlip()->int:
	rng.randomize()
	return rng.randi_range(0, 1)

func _process(delta: float) -> void:
	if(enabled):
		var new_offset: Vector2 = get_scroll_offset() + direction * delta
		set_scroll_offset( new_offset )


func _on_Arena_all_enemies_defeated():
	enabled = false
	$ColorPlayer.stop()
	pass # Replace with function body.


func _on_Arena_new_round_started(enemies_left):
	enabled = true
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	
	if(anim_name == "GlowFadeIn"): #shift the grid colors when the grid has actually faded in
		$ColorPlayer.play("ShiftGridColor")
	pass # Replace with function body.
