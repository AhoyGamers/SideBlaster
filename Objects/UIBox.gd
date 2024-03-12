extends Node2D
signal clicked(item, name)
#what item should be spawned when this box is clicked?
var item = load("res://Objects/Blaster.tscn")
var itemName:= "Blaster"
var buttonName:="Blaster"
export var square_starting_item_count = 1
export var blasters_per_round:=1
var itemCount:=0
export var enabled:= false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_starting_item_count()
	updateItemLabel()
	setHoverBoxVisibility(false)

func set_starting_item_count():
	if(GlobalVars.shape == "Square"):
		itemCount = square_starting_item_count

func _on_ClickArea_mouse_entered():
	if(enabled):
		setHoverBoxVisibility(true)

func _on_ClickArea_mouse_exited():
	if(enabled):
		setHoverBoxVisibility(false)

func setHoverBoxVisibility(visibility: bool):
	$HoverBox.visible = visibility

#spawn the specified item at player mouse when UIBox clicked
func _on_ClickArea_input_event(viewport, event, shape_idx):
	if enabled:
		if event is InputEventMouseButton:
			if(event.is_pressed()):
				click()

func click():
	emit_signal("clicked",item, itemName)

#decrease how many items this box holds and can dispense
func decreaseItemCount(amount: int):
	itemCount-=amount
	updateItemLabel()
	if(itemCount == 0):
		disable()

#Inrease how many items this box holds and can dispense
#Typically triggered from parent nodes, IE. the arena
func increaseItemCount(amount: int):
	itemCount+=amount
	updateItemLabel()
	if(itemCount > 0):
		enable()

#enables functionality of the button
func enable():
	setHoverBoxVisibility(false)
	enabled = true
	
func updateItemLabel():
	$ItemLabel.setText(itemName + " x" + str(itemCount))
	
#disable functionality of box and let the player know
func disable():
	setHoverBoxVisibility(true)
	enabled = false
	
func getItemCount() -> int:
	return itemCount

func _on_ShapeBuilder_enable_upgrade_buttons():
	if(itemCount < blasters_per_round):
		increaseItemCount(blasters_per_round)
	pass # Replace with function body.
