extends Node2D
var children

# Called when the node enters the scene tree for the first time.
func _ready():
	#cache all of the keyConfig children so we can enable/disable them
	children = GlobalFuncs.getObjectsInGroup("KeyConfig",self)
	pass # Replace with function body.

#triggered when another keyConfig is clicked, disabled the rest from activating
func disableButtons():
	for child in children:
		child.disableButtonPress()
	pass

func enableButtons():
	for child in children:
		child.enableButtonPress()

func removeDuplicateKeys(key):
	for keyConfig in children:
		#skip the most recent button the player pressed
		if(!keyConfig.recentlyClicked):
			#check if the key registered is a duplicate
			if(keyConfig.button == key):
				#if so erase the duplicate keyConfig
				keyConfig.erase()
		else:
			#else we are checking the keyConfig that was just modified, so don't
			#do anything except tell it to no lonber be recently clicked
			keyConfig.recentlyClicked = false
	pass

######
#All the connections between the keyConfigs
######
func _on_KeyConfig_pressed():
	disableButtons()
	
func _on_KeyConfig2_pressed():
	disableButtons()

func _on_KeyConfig3_pressed():
	disableButtons()

func _on_KeyConfig4_pressed():
	disableButtons()
	
func _on_KeyConfig5_pressed():
	disableButtons()
	
func _on_KeyConfig6_pressed():
	disableButtons()

func _on_KeyConfig7_pressed():
	disableButtons()
	
func _on_KeyConfig8_pressed():
	disableButtons()

func _on_KeyConfig_binding_changed(key):
	enableButtons()
	removeDuplicateKeys(key)

func _on_KeyConfig2_binding_changed(key):
	enableButtons()
	removeDuplicateKeys(key)

func _on_KeyConfig3_binding_changed(key):
	enableButtons()
	removeDuplicateKeys(key)

func _on_KeyConfig4_binding_changed(key):
	enableButtons()
	removeDuplicateKeys(key)

func _on_KeyConfig5_binding_changed(key):
	enableButtons()
	removeDuplicateKeys(key)

func _on_KeyConfig6_binding_changed(key):
	enableButtons()
	removeDuplicateKeys(key)
	
func _on_KeyConfig7_binding_changed(key):
	enableButtons()
	removeDuplicateKeys(key)
	
func _on_KeyConfig8_binding_changed(key):
	enableButtons()
	removeDuplicateKeys(key)
