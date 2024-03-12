extends Camera2D

# This script assumes that the zoom.x and zoom.y are always the same.
signal finish_zoom
var current_zoom
var min_zoom
var max_zoom
export var zoom_factor = 0.37 # < 1 = zoom_in; > 1 = zoom_out
export var transition_time = 0.75 #how long will animation take

func _ready():
	calculate_zoom()

func calculate_zoom():
	max_zoom = zoom.x
	min_zoom = max_zoom * zoom_factor

func _on_Arena_player_hit():
	#player scale-=scale*0.13
	zoom_factor-=zoom_factor*0.13
	calculate_zoom()

func _on_Arena_player_healed():
	zoom_factor+=zoom_factor*0.13

func zoom_in(new_offset):
	calculate_zoom()
	transition_camera(Vector2(min_zoom, min_zoom), new_offset)

func zoom_out(new_offset):
	transition_camera(Vector2(max_zoom, max_zoom), new_offset)

func transition_camera(new_zoom, new_offset):
	if new_zoom != current_zoom:
		current_zoom = new_zoom
		$Tween.interpolate_property(self, "zoom", get_zoom(), current_zoom, transition_time, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
		$Tween.interpolate_property(self, "offset", get_offset(), new_offset, transition_time, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
		$Tween.start()


func _on_Tween_tween_completed(object, key):
	emit_signal("finish_zoom")
	pass # Replace with function body.
