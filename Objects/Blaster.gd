extends Node2D
signal item_placed(name,instance)

#is the blaster picked up by the player?
var isPickedUp:= true

#is the blaster in a valid position to be placed?
var inValidPosition:= false

#is the blaster on the outside of the shape?
var outsideShape:= true

#what key makes this specific blaster fire?
var assigned_key:= "fire_1"
var assigned_controller_key:="fire_1"

var enabled:=true

var projectile_path = load("res://Objects/Projectile.tscn")

var is_shooting:=false

 #Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#add a check for outsideShape later by adding signals from the BadArea
	if isPickedUp:
		if GlobalVars.controller_connected:
			move_to_controller()
		elif(!GlobalVars.controller_connected):
			move_to_mouse()
	if(!GlobalVars.paused):
		if is_shooting && enabled:
			shoot()
	pass

func _input(event):
	#during gameplay, check if player is pressing the fire key
	if event.is_action_pressed(assigned_key):
			is_shooting = true
	if event.is_action_released(assigned_key):
			is_shooting = false

	if(!GlobalVars.paused):
		if enabled && is_shooting:
			shoot()

	#during placement, check if player has clicked. If so, place the blaster in its spot
	if(isPickedUp && inValidPosition):
		if event is InputEventMouseButton: #mouse user check
			if(event.is_pressed()):
					togglePickUp()
		if(GlobalVars.controller_connected): #controller user check
			if(event.is_action_pressed("ui_accept")):
					togglePickUp()

func shoot():
	$SFX.play()
	var projectile = projectile_path.instance()
	var world = get_tree().get_root() 
	world.add_child(projectile)
	projectile.transform = $ProjectileSpawn.global_transform
	#disable self until cooldown completed
	enabled = false


func move_to_mouse():
	self.global_position = get_global_mouse_position()

func move_to_controller():
	self.global_position = GlobalVars.controllerMenuPostion

func togglePickUp():
	
	isPickedUp = !isPickedUp
	
	#if blaster has been placed in a valid spot
	if(!isPickedUp):
		#print("Blaster: Has been placed!")
		$AnimatedSprite.play("default")
		emit_signal("item_placed","Blaster",self)
		GlobalSignals.emit_signal("blaster_placed",assigned_key)

func isPickedUp():
	return isPickedUp

#when the blaster enters a good area from the Square/triangle/circleObjects 
#it turns green and allows the player to place it
func _on_Placement_area_entered(area):
	if(isPickedUp):
		if(!GlobalVars.controller_connected):
			if(area.is_in_group("GoodPlacementArea")):
				#print("Blaster: Valid area!")
				$AnimatedSprite.play("Valid")
				inValidPosition = true
				outsideShape=true
			elif(area.is_in_group("BadPlacementArea")):
				$AnimatedSprite.play("Invalid")
				inValidPosition = false
				outsideShape=false
			elif(area.is_in_group("Edge")):
				turnBlaster(area.angle)
				assigned_key = area.get_key()
			elif(area.is_in_group("BlasterPlacement")):
				$AnimatedSprite.play("Invalid")
				inValidPosition = false
				outsideShape=false
		elif(GlobalVars.controller_connected):
			#a little hacky- but the player can't go out of bounds due to collision
			#anyway. So just always set it valid. Otherwise lotsa headaches
			$AnimatedSprite.play("Valid")
			inValidPosition = true
			outsideShape=false
			if(area.is_in_group("Edge")):
				turnBlaster(area.angle)
				assigned_key = area.get_key()

#when blaster leaves a good palcement area, it should turn invalid again
func _on_Placement_area_exited(area):
	#get_overlapping_areas might be the key to solving
	#the weird placement issues
	if(isPickedUp):
		if(area.is_in_group("GoodPlacementArea")):
			$AnimatedSprite.play("Invalid")
			inValidPosition = false
		elif(area.is_in_group("BadPlacementArea")):
			$AnimatedSprite.play("Valid")
			inValidPosition = true
			outsideShape = true

func turnBlaster(degrees):
	set_global_rotation_degrees(degrees)
	
#triggered when the specific blast_timer in Shapebuilder scene is finished
#connected through code in the shapebuilder scene
func on_cooldown_complete():
	enabled = true
