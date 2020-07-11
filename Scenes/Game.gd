extends Node2D

export(PackedScene) var enemy
export(PackedScene) var fast_enemy
export(PackedScene) var star
export(PackedScene) var fuel

export var x_limit = 800
export var y_limit = 600

var score = 0
onready var rockets = [$Bombs/Bomb, $Bombs/Bomb2, $Bombs/Bomb3]

var wave = 2
var wave_cooldown = 4
var wave_threshold = 2

var clock = 0
var paused = true

onready var player = $Player

signal player_damaged


func _ready():
	randomize()


func start():
	paused = false
	$Player.paused = false


func _process(delta):
	if paused:
		return
	
	clock += delta
	if clock > wave_cooldown:
		wave += 1
		clock = 0
		spawn_enemies()


func spawn_enemies():
	var enemy_amount = wave/wave_threshold
	if enemy_amount > 0:
		enemy_amount = randi() % enemy_amount
	
	var fast_amount = wave/(wave_threshold*4)
	if fast_amount > 0:
		fast_amount = randi() % fast_amount
	
	for _i in range(enemy_amount):
		spawn_enemy(enemy)
	
	for _i in range(fast_amount):
		spawn_enemy(fast_enemy)
	
	for _i in range(randi() % 2):
		spawn_enemy(star)
	
	for _i in range(max(0, (randi() % 15) - 13) ):
		spawn_enemy(fuel)


func spawn_enemy(packed):
	var rand_x = [-16, x_limit+16][randi() % 2]
	var rand_y = randi() % y_limit
		
	var _new = packed.instance()
	add_child(_new)
	move_child(_new, get_child_count()-3)
	
	_new.position = Vector2(rand_x, rand_y)
	
	if rand_x == x_limit+16:
		_new.set_direction(-1)
	else:
		_new.set_direction(1)


func get_score():
	return score


func input_received(button):
	player.receive_input(button)


func send_input_system(key, action):
	$Player.receive_input(key, action)


func _on_Player_damaged():
	emit_signal("player_damaged")


func _on_Player_scored():
	score += 1
	$Label.text = str(score)


func _on_Player_exploded(explosions):
	$AnimationPlayer.play("explosion")
	rockets[explosions].visible = false


func _on_Player_gotten_fuel(explosions):
	rockets[explosions].visible = true
