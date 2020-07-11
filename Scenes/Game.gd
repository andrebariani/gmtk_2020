extends Node2D

export(PackedScene) var enemy
export(PackedScene) var fast_enemy

export var x_limit = 800
export var y_limit = 600

var wave = 3
var wave_cooldown = 4
var wave_difficulty = 4

var clock = 0

onready var player = $Player

signal player_damaged


func _process(delta):
	clock += delta
	if clock > wave_cooldown:
		wave += 1
		clock = 0
		spawn_enemies()


func spawn_enemies():
	var enemy_amount = wave/wave_difficulty
	if enemy_amount > 0:
		enemy_amount = randi() % enemy_amount
	
	var fast_amount = wave/(wave_difficulty*4)
	if fast_amount > 0:
		fast_amount = randi() % fast_amount
	
	for i in range(enemy_amount):
		spawn_enemy(enemy)
	
	for i in range(fast_amount):
		spawn_enemy(fast_enemy)


func spawn_enemy(packed):
	var rand_x = [-16, x_limit+16][randi() % 2]
	var rand_y = randi() % y_limit
		
	var _new = packed.instance()
	add_child(_new)
	move_child(_new, get_child_count()-1)
	
	_new.position = Vector2(rand_x, rand_y)
	
	if rand_x == x_limit+16:
		_new.set_direction(-1)
	else:
		_new.set_direction(1)


func input_received(button):
	player.receive_input(button)


func _on_Player_damaged():
	emit_signal("player_damaged")
