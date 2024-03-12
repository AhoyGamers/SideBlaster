extends Node2D
export var action:= "fire_1"
var button = "W"
var awaitingInput:=false
var enabled = true

#used in keyCOnfigManager to determine most recent button clicked
var recentlyClicked = false
signal pressed
signal binding_changed(key)

# Called when the node enters the scene tree for the first time.
func _ready():
	showCurrentButton()
	pass # Replace with function body.

#On scene start, update text to show current key binding
func showCurrentButton():
	var keyList = InputMap.get_action_list(action)
	var key = keyList[0].as_text()
	button = key
	setText(button)
	pass

#triggered from KeyConfigMananger, erases the action from the InputMap 
#because a different KeyConfig just got updated as a duplicate of this one
func erase():
	button = "NULL"
	setText("No key set!")
	eraseActionKey()
	

#occurs whenever the user inputs something, like a key press
func _input(event):
	if(awaitingInput):
		if event is InputEventKey:
			awaitingInput = false
			var key = event.get_scancode()
			var isValidKey = checkKey(key)
			if(isValidKey):
				var keyString = OS.get_scancode_string(event.physical_scancode)
				setText(keyString)
				awaitingInput = false
				modifySettings(event)
				recentlyClicked = true
				emit_signal("binding_changed",keyString)
				button = keyString
				

func checkKey(key) -> bool:
	#first check if key is outside the letters A-Z
	if key < 65 or key > 90:
		#then check if key is not one of the arrow keys
		if key < 16777231 or key > 16777234:
			return false
	return true
	

func _on_Button_pressed():
	if(enabled):
		if(awaitingInput):
			awaitingInput = false
			setText(button)
			pass
		else:
			emit_signal("pressed")
			awaitingInput = true
			setText("Press any key...")
			button = "NULL"
	pass # Replace with function body.

func setText(text):
	$RichTextLabel.clear()
	$RichTextLabel.add_text(text)
	resizeButtonToText(text)

func resizeButtonToText(text):
	#TODO? Check if the tab,shift, or left/right buttons were mapped? Those are longer than 1
	if(awaitingInput):
		#then make the size of the panel equal to the "press any key" text
		$Panel.rect_size = Vector2(203,40)
		$Panel/Button.rect_size = Vector2(197,33)
		$Panel/VBoxContainer.rect_size = Vector2(204,39)
		$RichTextLabel.rect_size = Vector2(435,61)
	elif(text == "No key set!"):
		$Panel.rect_size = Vector2(162,40)
		$Panel/Button.rect_size = Vector2(153,33)
		$Panel/VBoxContainer.rect_size = Vector2(160,39)
		$RichTextLabel.rect_size = Vector2(301,61)
	elif(text.length() == 5 or text.length() == 4):
		#the size for buttons "down","left","right"
		$Panel.rect_size = Vector2(86,40)
		$Panel/Button.rect_size = Vector2(78,33)
		$Panel/VBoxContainer.rect_size = Vector2(87,39)
		$RichTextLabel.rect_size = Vector2(145,61)
		pass
	else:
		#then make the size of the panel equal one character width
		$Panel.rect_size = Vector2(40,40)
		$Panel/Button.rect_size = Vector2(34,33)
		$Panel/VBoxContainer.rect_size = Vector2(40,39)
		$RichTextLabel.rect_size = Vector2(63,61)
		

func modifySettings(event):
	#erase the old bindings
	eraseActionKey()
	# Add the new key binding
	InputMap.action_add_event(action, event)
	#debug printing new binfding
	#var bindings = InputMap.get_action_list(action)
	#var keyString = OS.get_scancode_string(bindings[0].physical_scancode)
	#print("ModifySettings: button for fire_1 is " + keyString)

func eraseActionKey():
	for old_event in InputMap.get_action_list(action):
			InputMap.action_erase_event(action, old_event)

func disableButtonPress():
	enabled = false
	
func enableButtonPress():
	enabled = true

	
