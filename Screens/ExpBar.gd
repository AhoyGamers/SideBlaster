extends TextureProgress
var totalEnemies
var enemiesDefeated:= 0

func _ready():
	set_boundry()

#change the "progress" texture based on the chosen shape
func set_boundry():
	if(GlobalVars.shape == "Square"):
		set_Square()
	elif(GlobalVars.shape == "Triangle"):
		set_triangle()
	elif(GlobalVars.shape == "Kite"):
		set_kite()

#triggered when arena emits the "EnemyDestroyed" signal
func _on_Arena_EnemyDestroyed():
	enemiesDefeated+=1
	updateBar()

#upates the shown value of the exp bar
func updateBar():
	self.value = enemiesDefeated
	#print("ExpBar: Player has " + str(self.value) + " exp out of " + str(self.max_value))

func _on_Arena_all_enemies_defeated():
	enemiesDefeated=0
	self.max_value = totalEnemies
	updateBar()

func _on_Arena_new_round_started(newTotal):
	totalEnemies = newTotal
	self.max_value = totalEnemies
	#print("ExpBar:Player must defeat " + str(self.max_value) + " enemies!")

func set_Square():
	var squareTexture = load("res://assets/enemySquare.png")
	self.set_progress_texture(squareTexture)
	rect_position = Vector2(-30,-46) 
	self.margin_left = -30
	self.margin_top = -44
	self.margin_right = 32
	self.margin_bottom = 16
	
func set_triangle():
	var triangleTexture = load("res://assets/filled_Triangle.png")
	self.set_progress_texture(triangleTexture)
	rect_position = Vector2(-30,-44)
	margin_left = -30
	margin_top = -27
	margin_right = 32
	margin_bottom = 16

func set_kite():
	var texture = load("res://assets/filled_kite.png")
	self.set_progress_texture(texture)
	rect_position = Vector2(-31,-44)
	margin_left = -31
	margin_top = -44
	margin_right = 35
	margin_bottom = 12
	
