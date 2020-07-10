extends Node2D

export(PackedScene) var enemy
export(PackedScene) var fast_enemy

export var x_limit = 800
export var y_limit = 600

var wave = 0
var difficulty = 0
var spawn_cooldown = 2

var clock = 0

onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	clock += delta
	if clock > spawn_cooldown:
		spawn_enemy()


func spawn_enemy():
	var rand_x = [0, x_limit][randi() % 2]
	var rand_y = randi() % y_limit


func input_received(button):
	player.receive_input(button)
