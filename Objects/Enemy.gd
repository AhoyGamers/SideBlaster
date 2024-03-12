extends Node2D
signal crashedIntoPlayer()
signal deleted()
export var min_spawn_x_val = -500 #600
export var max_spawn_x_val = 500

export var min_spawn_y_val = -380 #400
export var max_spawn_y_val = 380

export var health = 1.0
export var totalHP = 1.0
#maximum possible HP each instance COULD start with, passed from Arena
export var maxHP = 3
export var follows_player:=false
var minSpeed = GlobalVars.minEnemySpeed
var maxSpeed = GlobalVars.maxEnemySpeed
var rng = RandomNumberGenerator.new()

export var shrink_duration:= 0.25

export var enabled:=true
# Called when the node enters the scene tree for the first time.
func _ready():
	randomizeStart()

func randomizeStart():
	
	#randomize where the enemy spawns
	randomizeSpawnPoint()
	
	#randomize the direction of the enemy
	randomizeVelocity()
	
	randomizeSpeed()
	
	randomizeHP()
	
	setScale()
	
func setScale():
	$EnemyBody.scale = getHealthScale()

func getHealthScale() -> Vector2:
	return Vector2(0.3+(0.05*health),0.3+(0.05*health))

func randomizeSpeed():
	var randomNum=generateRanNum(minSpeed,maxSpeed)
	$EnemyBody.speed = randomNum
	
func randomizeHP():
	totalHP = int(floor(generateRanNum(1,maxHP)))
	health = totalHP
	updateSpriteHue()

func randomizeSpawnPoint():
	var randomNum = int(floor(generateRanNum(1,5)))
	if randomNum == 1:
		#spawn enemy above player, randomize X value
		var randomX = generateRanNum(-579,620)
		global_position=Vector2(randomX,-395)
	elif randomNum == 2:
		#spawn enemy below player, randomize X value
		var randomX = generateRanNum(-579,620)
		global_position=Vector2(randomX,421)
	elif randomNum == 3:
		#spawn enemy from right side, randomize Y value
		var randomY = generateRanNum(-403,438)
		global_position=Vector2(574,randomY)
	elif randomNum == 4:
		#spawn enemy from left side, randomize Y value
		var randomY = generateRanNum(-403,438)
		global_position=Vector2(-533,randomY)

func randomizeVelocity():
	var randomNum = 0#coinFlip()
	var velocity:=Vector2()
	if randomNum == 0:
		#enemy does NOT follow the player
		
		if global_position.x < 0: #enemy is on left side of screen
			velocity.x = generateRanNum(0,1)
		else: #enemy is on right side of screen
			velocity.x = generateRanNum(-1,0)
		
		if global_position.y > 0: #enemy is below screen
			velocity.y = generateRanNum(-1,0)
		else:
			velocity.y = generateRanNum(0,1)
		$EnemyBody.setVelocity(velocity)
	else:
		#enemy DOES follow the player
		follows_player = true


func coinFlip()->int:
	rng.randomize()
	return rng.randi_range(0, 1)
	
func generateRanNum(minimum,maximum)->float:
	rng.randomize()
	return rng.randf_range(minimum,maximum)

func _on_EnemyBody_shot():
	if(enabled):
		health-=1.0
		updateSpriteHue()
		if(health > 0):
			shrink()
		else: #enemy is now dead so tween them out and disable them
			enabled = false
			collapse()

func shrink():
	shrinkBody(getHealthScale())

#shrink the enemy sprite's scale by the shrink amount over half a second
func shrinkBody(amount):
	var curScale = $EnemyBody.scale
	var finScale = amount
	#TODO: CHange easing type?
	#print("Enemy: Tweening from " + str(curScale) + " to " + str(finScale))
	$Tween.interpolate_property($EnemyBody,"scale",curScale,finScale,shrink_duration)
	$Tween.start()

func fadeParticles():
	var curMod = $EnemyBody/Particles.modulate
	var finMod = Color(0.5,0.5,0.5,0)
	#TODO: CHange easing type?
	#print("Enemy: Tweening particles from " + str(curMod) + " to " + str(finMod))
	$Tween.interpolate_property($EnemyBody/Particles,"modulate",curMod,finMod,shrink_duration)
	$Tween.start()

#change the hue of the enemy sprite
func updateSpriteHue():
	#0.3 is the minimum hue needed to be able to see the squares
	var hue = (0.12*health) + 0.3
	
	#This function is called in other situations than crashing into
	#the player, but i'm leaving the name.
	#Affects the EnemySprite script to change the hue part of the modulate
	emit_signal("crashedIntoPlayer",hue)

#WARNING: I DON'T THINK THIS DOES ANYTHING
func _on_EnemyBody_crashedIntoPlayer():
	if(enabled):
		emit_signal("crashedIntoPlayer")


func _on_EnemyBody_outOfBounds():
	self.queue_free()

#collapse the enmy into nonexistence. Should trigger when enemy shot and health depleted
func collapse():
	var curScale = $EnemyBody.scale
	#turn off particles
	fadeParticles()
	
	#make the entire enemy node shrink into nonexistence
	shrinkBody(Vector2(0,0))
	
	
func delete_self():
	emit_signal("deleted")
	self.queue_free()
	
#after enemy has fully faded out, delete
func _on_DespawnTimer_timeout():
	pass

func _on_Tween_tween_completed(object, key):
	#somewhat clunky, but the way the collapse function works has it
	#1. disable particles (key=modulate)
	#2. Shrink enemy down to 0 (key=scale)
	#So it just checks that the key equals the last tween executed in the collapse
	#function. If you edit the collapse function make sure to edit me too!
	if(health <= 0 && str(key) == ":scale" && $EnemyBody.scale.x <= 0.001):
		$EnemyBody.disableMovement()
		delete_self()
		
