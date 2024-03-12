extends AnimationPlayer
var animation_name:= "No animation set"

#adds animation to object dynamically
func addAnimToObject(object, parameters: Array, animName: String,startValue, endValue,startTime: float, endTime: float, easing: String):
	var animation = Animation.new()
	var objectName = object.name
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	var parametersString:=convertParametersToString(parameters)
	var easingType:= 0
	#determine the type of easing based on what type we specified
	match easing:
		"in-out":
			easingType = -2.0
		"out-in":
			easingType = -0.5
		"constant":
			easingType = 0.0
		"out":
			easingType = 0.5
		"in":
			easingType = 2
		"linear":
			easingType = 1.0
		_:
			print("CardAnimations addAnimToObject says: ERROR UNKNOWN EASING TYPE SET FOR ANIMATION " + animName)
	
	#now we actually add the animation
	animation.track_set_path(track_index, objectName + ":" + parametersString)
	#THIS IS MSOT IMPORTANT LINE: If not used, then animation is locked to 1 second
	animation.set_length(endTime-startTime)
	animation.track_insert_key(track_index, startTime, startValue)
	animation.track_insert_key(track_index, endTime, endValue)
	animation.track_set_key_transition(track_index,0,easingType) 
	add_animation(animName,animation)
	animation_name = animName
	#add a signal to auto delete self when aniamtion is finished playing
	self.connect("animation_finished", self, "_on_animation_finished")
	
#converts array into format item1:item2:item3...etc
func convertParametersToString(array: Array) -> String:
	var parameters:= ""
	for item in array:
		parameters+=item + ":"
	return parameters
	
func _on_animation_finished(anim_name: String):
	queue_free()
	
func on_playAnimation_signal_received(received_anim_name: String):
	if(received_anim_name == animation_name):
		play(animation_name)
