extends Node2D
signal move(direction,cur_selection)
var cur_selected_button = self
var enabled:=false
var already_emitted:=false
export (float) var AxisBuffer = 0.5
func _input(event):
	if(enabled):
		if(event.is_action_pressed("ui_accept")):
			cur_selected_button.click()
			self.modulate = Color(1,1,1,0)
			enabled = false
		else: #otherwise check what direction the player wants to move in
			var direction = "none"
			if(event.is_action_pressed("menu_up")):
				direction = "up"
			elif(event.is_action_pressed("menu_down")):
				direction = "down"
			elif(event.is_action_pressed("menu_left")):
				direction = "left"
			elif(event.is_action_pressed("menu_right")):
				direction = "right"
			
			if(direction != "none"):
				emit_signal("move",direction,cur_selected_button)

func _on_Area2D_area_entered(area):
	var areaOwner = area.get_owner()
	#print("ControllerSelector: " + str(areaOwner.get_owner()) + " area entered!")
	if(areaOwner.is_in_group("Upgrade_Button")):
		#print("ControllerSelector: The " + str(areaOwner) + "node was set as current button!")
		cur_selected_button = areaOwner

func click():
	if(enabled):
		print("ControllerSelector: WARNING, NO CUR_SELECTED_BUTTON YET PLAYER CLICKED")

func _on_ShapeBuilder_enable_upgrade_buttons():
	enabled = true
	self.modulate = Color(1,1,1,1)

func _on_ShapeBuilder_player_finished_building():
	enabled = false
	self.modulate = Color(1,1,1,0)
