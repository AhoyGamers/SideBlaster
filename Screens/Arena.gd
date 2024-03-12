extends Node2D
var rng = RandomNumberGenerator.new()
#### signals #############
#Sent out when enemy is defeated by player
#connected to: Player.ExpBar through the editor
signal EnemyDestroyed 

#sent out when all enemies defeated
#connecred to Player.ExpBar through editor
signal all_enemies_defeated

#sent out when a new round has begun after zoom out, sends out how
#many enemies must be defeated until next level up
#connected to Player.ExpBar through editor
signal new_round_started(enemiesLeft)

#sent out when player is hit. Causes them to shrink and gain speed
signal player_hit()

signal max_HP_reached

signal player_healed
###########################

#should the game be zooming in on the player?
var isZoomingIn:= false
var zoomObject
var enemy = load("res://Objects/EnemySquare.tscn")
var obstacle = load("res://Objects/Obstacle.tscn")
#should the game be zooming in out the player?
var isZoomingOut:= false
#is the player immune to enemies crashing into them?
var playerIsImmune:=false

#did the player choose to heal in the last upgrade? Used for camera zoomout.
var player_healed:=false

var canSpawnEnemies:=false
#set the starting values of the entire game based on the global variables
var maxEnemies:= GlobalVars.maxEnemies
var minEnemySpeed:=GlobalVars.minEnemySpeed
var maxEnemySpeed:=GlobalVars.maxEnemySpeed
var maxEnemyHP:=GlobalVars.maxStartEnemyHP
var enemiesLeft:= maxEnemies
var enemiesSpawned = 0
var enemiesToSpawn:= maxEnemies
export (int) var enemies_per_round:=1
var round_count:=0
export var speedToAdd:=5
export var player_hp:=3
var enemies_on_screen:=0
export (int) var max_obstacles_on_screen:=3
var num_of_obstacles:=0
export (int) var max_obstacle_spawn_time:=10
export (int) var min_obstacle_spawn_time:=5
export (int) var max_obstacles_per_round:=3
export (int) var max_enemies_on_screen:=3
export (int) var max_enemy_spawn_time:=7
export (int) var min_enemy_spawn_time:=3
# Called when the node enters the scene tree for the first time.
func _ready():
	reset_shape_counts()
	give_player_upgrade()

func reset_shape_counts():
	if(GlobalVars.shape == "Triangle"):
		GlobalVars.survived_triangle = 0
	elif(GlobalVars.shape == "Square"):
		GlobalVars.survived_square = 0
	elif(GlobalVars.shape == "Kite"):
		GlobalVars.survived_kite = 0

func zoom_in_on_player():
	isZoomingIn = true
	zoomObject = $Player.get_node("ShapeBuilder")
	#$AnimationPlayer.play("GlowOut")
	$Camera.zoom_in(zoomObject.global_position)

func zoom_out_on_player():
	isZoomingOut = true
	zoomObject = self
	#$AnimationPlayer.play("GlowFadeIn")
	$Camera.zoom_out(Vector2(0, 0))

func _on_Camera_finish_zoom():
	if(isZoomingIn):
		isZoomingIn = false
		$Player.triggerUpgrade()
	elif(isZoomingOut):
		isZoomingOut = false
		GlobalVars.paused = false
		$Player.enableMovement()
		if(player_healed):
			player_healed=false
			growPlayer()
		startNewRound()

func startNewRound():
		count_shape()
		if(round_count >= 1):
			increaseDifficulty()
		#minor bug: This means the starting round have one extra enemy than intended
		enemiesLeft = maxEnemies
		#print("Arena: " + str(enemiesLeft) + " enemies to next round")
		enemiesSpawned = 0
		#print("Arena: fight " + str(enemiesLeft) + " enemies!")
		resetEnemySpawns()
		restartTimers()
		emit_signal("new_round_started",enemiesLeft)
		round_count+=1

func count_shape():
	if(GlobalVars.shape == "Triangle"):
		GlobalVars.survived_triangle+=1
	if(GlobalVars.shape == "Kite"):
		GlobalVars.survived_kite+=1
	elif(GlobalVars.shape == "Square"):
		GlobalVars.survived_square+=1

func increaseDifficulty():
	minEnemySpeed+=speedToAdd
	maxEnemySpeed+=speedToAdd
	if maxEnemyHP < GlobalVars.maxEndEnemyHP:
		maxEnemyHP+=1
	maxEnemies+=enemies_per_round
	max_obstacles_on_screen+=max_obstacles_per_round
	if(round_count % 2 == 0):
		if(max_enemy_spawn_time > 2):
			max_enemy_spawn_time-=1
		if(min_enemy_spawn_time > 1):
			min_enemy_spawn_time-=1
		if(max_obstacle_spawn_time > 2):
			max_obstacle_spawn_time-=1
		if(min_obstacle_spawn_time > 1):
			min_obstacle_spawn_time-=1
		#print("Arena: Decreased timers! Enemies spawn at most " + str(max_enemy_spawn_time) + " seconds and obstacles spawn at most" + str(max_obstacle_spawn_time) + " seconds")

func resetEnemySpawns():
	enemiesToSpawn = maxEnemies
	
func restartTimers():
	$EnemySpawnTimer.set_paused(false)
	$EnemySpawnTimer.start()
	$ObstacleSpawnTimer.set_paused(false)
	$ObstacleSpawnTimer.start()

func give_player_upgrade():
	if(player_hp > 0):
		GlobalVars.paused = true
		$Player.disableMovement()
		$AnimationPlayer.play("GlowOut")
		zoom_in_on_player()


func _on_Player_player_finished_building():
	$AnimationPlayer.play("GlowFadeIn")
	zoom_out_on_player()
	
func _on_EnemySpawnTimer_timeout():
	if(enemies_on_screen < max_enemies_on_screen):
		spawnEnemy()
		enemies_on_screen+=1
		#print("Arena: enemy spawned. " + str(enemies_on_screen) + " enemies out of " + str(max_enemies_on_screen))
	#then randomize timer
	$EnemySpawnTimer.wait_time = generateRanNum(min_enemy_spawn_time,max_enemy_spawn_time)


func _on_ObstacleSpawnTimer_timeout():
	#print("spawning obstacle!")
	if(num_of_obstacles < max_obstacles_on_screen):
		spawnObstacle()
	#else:
		#print("Arena: Tried to spawn obstacle but too many on screen!")
	#then randomize timer
	$ObstacleSpawnTimer.wait_time = generateRanNum(min_obstacle_spawn_time,max_obstacle_spawn_time)

func generateRanNum(minimum,maximum)->float:
	rng.randomize()
	return rng.randf_range(minimum,maximum)

func spawnEnemy():
	var enemyInstance = enemy.instance()
	enemyInstance.maxHP = maxEnemyHP
	
	#enemiesToSpawn-=1 possibly delete me?
	add_child(enemyInstance)
	
	#connect enemy to the arena so it can run gameOver and enemy destruction
	enemyInstance.connect("crashedIntoPlayer",self,"on_player_crash")
	enemyInstance.connect("deleted",self,"on_enemy_destroyed")
	if(enemiesToSpawn <= 0):
		pauseSpawnTimer()

func spawnObstacle():
	#print("Arena: Obstacle spawned")
	#print("Arena: " + str(num_of_obstacles) + " obstacles in play out of " + str(max_obstacles_on_screen))
	num_of_obstacles+=1
	var enemyInstance = obstacle.instance()
	enemyInstance.maxHP = maxEnemyHP
	add_child(enemyInstance)
	
	#connect enemy to the arena so it can run gameOver and enemy destruction
	enemyInstance.connect("crashedIntoPlayer",self,"on_player_crash")
	enemyInstance.connect("deleted",self,"on_enemy_destroyed")
	enemyInstance.connect("out_of_bounds",self,"on_obstacle_out_of_bounds")

func on_obstacle_out_of_bounds():
	#print("Arena: Obstacle went out of bounds")
	num_of_obstacles-=1
	#print("Arena: " + str(num_of_obstacles) + " obstacles in play out of " + str(max_obstacles_on_screen))

func pauseSpawnTimer():
	$EnemySpawnTimer.set_paused(true)

func pauseObstacleTimer():
	$ObstacleSpawnTimer.set_paused(true)

func on_player_crash():
	#print("Arena: Player has crashed!")
	if(!playerIsImmune):
		playerIsImmune = true
		hurt_player()
		$Death.play()
		if(player_hp <= 0):
			game_over()
		else:
			$AnimationPlayer.play("PlayerHit")

func hurt_player():
	player_hp-=1
	emit_signal("player_hit") #mits to Player and ShapeBuilder

func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "PlayerHit"):
		playerIsImmune = false

func game_over():
	$Player.queue_free()
	var game_over = load("res://Screens/GameOver.tscn")
	var instance = game_over.instance()
	add_child(instance)
	instance.position = Vector2(-460,-316)
	
func on_enemy_destroyed():
	#print("Arena: enemy destroyed! Emitting destoyed signal")
	emit_signal("EnemyDestroyed")
	enemiesLeft-=1
	enemies_on_screen-=1
	#print("Arena: " + str(enemiesLeft) + " to go")
	$Death.play()
	if(enemiesLeft <= 0):
		#print("Arena: All enemies defeated!")
		emit_signal("all_enemies_defeated")
		$AnimationPlayer.play("GlowFadeIn")
		give_player_upgrade()

func _on_ShapeBuilder_increase_HP(amount):
	player_hp+=amount
	emit_signal("player_healed")
	player_healed=true
	if(player_hp >= GlobalVars.maxPlayerHP):
		emit_signal("max_HP_reached")

#if the player chose to heal last round, make them grow after zoomout
func growPlayer():
	var curScale = $Player.scale
	var finScale = $Player.scale+($Player.scale*0.13)
	var shrink_duration=0.25
	$Tween.interpolate_property($Player,"scale",curScale,finScale,shrink_duration)
	$Tween.start()



