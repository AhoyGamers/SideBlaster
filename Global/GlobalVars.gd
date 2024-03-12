extends Node
var shape:= "Triangle"
var played_music:=false
var paused:= false
var maxEnemySpeed:=150
var minEnemySpeed:=100
var maxEnemies:=3
var controller_connected:=false
#maximum SPAWNED enemy HP for the start of the game
#If you want to set the maximum per round, visit Arena.gd
const maxStartEnemyHP:=1
const maxEndEnemyHP:=8
const maxPlayerHP:=6

var playerPos:=Vector2(0,0)
var controllerMenuPostion:=Vector2(0,0)

#how many rounds required to survive to unlock each shaoe
const required_triangle = 0
const required_square = 5
const required_kite = 5

#how many rounds as each shape
var survived_triangle = 0
var survived_square = 0
var survived_kite = 0

#has the pkayer unlocked each shape?\
var unlocked_triangle:=true
var unlocked_square:=false
var unlocked_kite:=false
