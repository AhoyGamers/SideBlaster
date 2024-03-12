extends Node2D
signal player_finished_building 
signal player_started_building #connected to the control scenes (Objects/ControlSchemes)
signal ready_for_zoomout #connected to the control scenes
signal enable_upgrade_buttons
signal decrease_cooldown(amount)
signal increase_HP(amount)
const cooldown_decrease_amount:= 0.1 #when clicked, how much should cooldownbutton decrease?
var round_count:= 0
var min_cooldown_reached:=false
var HP_increase_amount:=1
var player_building:=false
#Has the player reached max HP?
var maxHPReached:=false

#is a controller connected to the game?
var controller_connected:=GlobalVars.controller_connected

#the names of the current farthest left and right buttons for controller selection
#they both start as blaster because the first option in any run is placing blaster
var farthest_left_button = "Blaster"
var farthest_right_button = "Blaster"

#should we be searching for a controller at each input?
var searching_for_controller:=true
# Called when the node enters the scene tree for the first time.
func _ready():
	#hide all the UI so they can fade in later
	$Instructions.modulate = Color(1,1,1,0)
	$UIBox.modulate = Color(1,1,1,0)
	$CoolDownUpgrade.modulate = Color(1,1,1,0)
	$HPButton.modulate = Color(1,1,1,0)
	#check if controller is unplugged/plugged
	Input.connect("joy_connection_changed",self,"_joy_connection_changed")
	#spawnControlDisplay()
	

#during the building phase, check to see if the player has connected a controller
func _joy_connection_changed(id,connected):
	#print("Shapebuilder: joystick " + str(id) + str(connected))
	if(connected == false):
		searching_for_controller = true
		$ControllorSelector.visible = true
		#print("ShapeBuilder: controller disconnected!")
	else:
		#print("ShapeBuilder: controller connected!")
		connect_controller()
	#print("ShapeBuilder: Updating controls!!")
	spawnControlDisplay()

func _input(event):
	if(searching_for_controller):
		controller_connected = (Input.get_connected_joypads().size()>0)
		GlobalVars.controller_connected = controller_connected
		searching_for_controller = false
		#print("ShapeBuilder: " + str(Input.get_connected_joypads().size()) + " connected joypads")
		spawnControlDisplay()

func connect_controller():
	controller_connected = true
	searching_for_controller = false
	GlobalVars.controller_connected = true
	$ControllorSelector.visible = true

#create and spawn a new item based on the UIBox's item
func _on_UIBox_clicked(item,name):
	if(name == "Blaster"):
		var playerPickedUpBlaster:= false
		var blasterChildren = GlobalFuncs.getObjectsInGroup("Blaster",self)
		for blaster in blasterChildren:
			if blaster.isPickedUp():
				playerPickedUpBlaster = true
				
		#only have one blaster active at a time, so if player
		#does NOT have one picked up, create a new blaster
		if(!playerPickedUpBlaster):
			playerPickedUpBlaster = true
			spawnInstance(item,name)

func spawnInstance(item,name):
	var instance = item.instance()
	add_child(instance)
	#let the item tell the shapeBuilder that is has been placed
	instance.connect("item_placed", self, "on_item_placed")
	if(!GlobalVars.controller_connected):
		instance.move_to_mouse()
	$UIBox.decreaseItemCount(1)

#after every item is placed, checked to see if every given UIBox has exhausted
#all of their stock. If so, then finish the building process
func on_item_placed(name,instance):
	if(name == "Blaster"):
		connect_blaster_to_cooldown(instance)
	
	var UIBoxes = GlobalFuncs.getObjectsInGroup("UIBox",self)
	var stillPiecesToPlace:=false
	for UIBox in UIBoxes:
		if UIBox.getItemCount() > 0:
			stillPiecesToPlace = true
			break
	
	if(!stillPiecesToPlace):
		finishBuilding()

#connect the blaster to the related cooldown timer
func connect_blaster_to_cooldown(instance):
	match(instance.assigned_key):
		"fire_1":
			$blast_timer.connect("timeout", instance, "on_cooldown_complete") 
		"fire_2":
			$blast_timer2.connect("timeout", instance, "on_cooldown_complete")
		"fire_3":
			$blast_timer3.connect("timeout", instance, "on_cooldown_complete")
		"fire_4":
			$blast_timer4.connect("timeout", instance, "on_cooldown_complete")
		"fire_5":
			$blast_timer5.connect("timeout", instance, "on_cooldown_complete")
		"fire_6":
			$blast_timer6.connect("timeout", instance, "on_cooldown_complete")
		"fire_7":
			$blast_timer7.connect("timeout", instance, "on_cooldown_complete")
		"fire_8":
			$blast_timer8.connect("timeout", instance, "on_cooldown_complete")

func triggerUpgrade():
	if(round_count > 0): #After the first round, add the cooldown/Heal upgrades
		place_upgrade_buttons()
	$AnimationPlayer.play("FadeInUI")
	emit_signal("player_started_building")

func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "FadeInUI"):
		enableBuilding()
		player_building = true
	elif(anim_name == "FadeOutUI"):
		emit_signal("player_finished_building")
		player_building = false

func enableBuilding():
	emit_signal("enable_upgrade_buttons")

func finishBuilding():
	round_count+=1
	$AnimationPlayer.play("FadeOutUI")
	emit_signal("ready_for_zoomout")

#show/hide the control scheme based on which shape the player is using
#To add a new scheme, duplicate one of the existing schemes
#then add another if statement here.
func spawnControlDisplay():
	controller_connected = (Input.get_connected_joypads().size()>0)
	if(controller_connected):
		#print("ShapeBuilder: enabling controller!")
		$ControlSchemes/JoystickControls.enabled = true
		$ControllorSelector.visible = true
		$ControlSchemes/SquareControls.enabled = false
		$ControlSchemes/SquareControls.visible = false
		$ControlSchemes/TriangleControls.enabled = false
		$ControlSchemes/TriangleControls.visible = false
		$ControlSchemes/KiteControls.enabled = false
		$ControlSchemes/KiteControls.visible = false
	else:
		$ControlSchemes/JoystickControls.enabled = false
		$ControlSchemes/JoystickControls.visible = false
		$ControllorSelector.visible = false
		#print("ShapeBuilder: enabling keyboard!")
		if(GlobalVars.shape == "Square"):
			$ControlSchemes/SquareControls.enabled = true
			$ControlSchemes/SquareControls.visible = true
		elif(GlobalVars.shape == "Triangle"):
			$ControlSchemes/TriangleControls.enabled = true
			$ControlSchemes/TriangleControls.visible = true
		elif(GlobalVars.shape == "Kite"):
			print("ShapeBuilder: kite controls enabled!")
			$ControlSchemes/KiteControls.enabled = true
			$ControlSchemes/KiteControls.visible = true
	if(player_building):
		#print("ShapeBuilder:Immediately changing control schemes!")
		emit_signal("player_started_building")

	
func _on_CoolDownUpgrade_clicked():
	emit_signal("decrease_cooldown",cooldown_decrease_amount)
	finishBuilding()
	pass # Replace with function body.

func _on_HPButton_clicked():
	emit_signal("increase_HP",1)
	finishBuilding()

func _on_blast_timer_min_cooldown_reached():
	$CoolDownUpgrade.visible = false
	min_cooldown_reached = true
	farthest_left_button = "Blaster"

#called before each upgrade, checks to see if player has max HP or Minimum Cooldown
#if so, hide those upgrade 
func place_upgrade_buttons():
	if(min_cooldown_reached):
		$CoolDownUpgrade.visible = false
		farthest_left_button = "Blaster"
	elif(!min_cooldown_reached):
		$CoolDownUpgrade.visible = true
		farthest_left_button = "Cooldown"
		
	if(maxHPReached):
		$HPButton.visible = false
		farthest_right_button = "Blaster"
	elif(!maxHPReached):
		$HPButton.visible = true
		farthest_right_button = "HP"

func _on_Arena_player_hit():
	maxHPReached = false

func _on_Arena_max_HP_reached():
	maxHPReached = true

#move the controllerselector in the specified direction
#direction is string statig up,down,left,or right
func _on_ControllorSelector_move(direction,cur_selected_button):
	if(player_building):
		var selected_button = cur_selected_button.buttonName
		if(direction == "right" && selected_button != farthest_right_button): 
			#as long as selector is NOT in the the farthest right positon, move it right
			$ControllorSelector.position.x += 201
		elif(direction == "left" && selected_button != farthest_left_button):
			#as long as selector is NOT in the the farthest left button, move it right
			$ControllorSelector.position.x -= 201
