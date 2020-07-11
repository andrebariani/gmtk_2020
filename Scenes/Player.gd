extends Node2D

export(PackedScene) var bullet
export(PackedScene) var explosion

export var dash_distance = 100
export var move_speed = 5
onready var target_y = self.position.y
var moving = false

var controls = {KEY_F:-1, KEY_G:-1, KEY_H:-1, KEY_J:-1}

var explosions = 3

signal damaged
signal scored
signal exploded
signal dash_distance

func _ready():
	emit_signal("dash_distance", dash_distance)


func _process(delta):
	var distance = target_y - self.position.y
	if distance > 2:
		distance = 1
	elif distance < -2:
		distance = -1
	else:
		if moving == true:
			moving = false
			$Ship.animate("idle")
		return
	
	moving = true
	self.position.y += move_speed*delta*distance


func receive_input(key, action):
	controls[key] = action


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode in controls:
			var input = controls[event.scancode]
			match(input):
				0: # UP
					dash(-1)
					self.rotation_degrees = 90
					$Ship.animate("move")
				1: # DOWN
					dash(1)
					self.rotation_degrees = 270
					$Ship.animate("move")
				2: # LEFT
					shoot(Vector2(-1, 0))
					self.rotation_degrees = 0
				3: # RIGHT
					shoot(Vector2(1, 0))
					self.rotation_degrees = 180
				4:
					shoot(Vector2(0, -1))
					shoot(Vector2(0, 1))
				5:
					explosion()


func damaged():
	$Ship.animate("blink")
	emit_signal("damaged")


func score():
	emit_signal("scored")


func dash(direction):
	target_y = target_y + int(!moving)*(direction * dash_distance)


func shoot(direction):
	var _new = bullet.instance()
	get_parent().add_child(_new)
	get_parent().move_child(_new, get_parent().get_child_count()-3)
	
	_new.position = self.position
	_new.set_direction(direction)


func explosion():
	if explosions <= 0:
		return
	
	explosions -= 1
	var _new = explosion.instance()
	get_parent().add_child(_new)
	get_parent().move_child(_new, get_parent().get_child_count()-3)
	_new.position = self.position
	emit_signal("exploded", explosions)
