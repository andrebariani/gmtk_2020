extends Node2D

export(PackedScene) var bullet
export(PackedScene) var explosion_bullet

export var dash_distance = 100
export var move_speed = 5
onready var target_y = self.position.y

var look_direction = 1

var controls = [null, null, null, null, null, null]

signal damaged
signal dash_distance

func _ready():
	emit_signal("dash_distance", dash_distance)

func _process(delta):
	var distance = target_y - self.position.y
	if distance > 1:
		distance = 1
	elif distance < -1:
		distance = -1
	else:
		return
	
	self.position.y += move_speed*delta*distance


func receive_input(key, action):
	controls[action] = key


func _input(event):
	if event is InputEventKey and event.pressed:
		var input = controls.find(event.scancode)
		match(input):
			0:
				dash(-1)
			1:
				dash(1)
			2:
				look(-1)
			3:
				look(1)
			4:
				shoot(bullet)
			5:
				shoot(explosion_bullet)


func damaged():
	emit_signal("damaged")


func dash(direction):
	target_y += direction * dash_distance


func look(direction):
	look_direction = direction


func shoot(bullet_type):
	var _new = bullet_type.instance()
	get_parent().add_child(_new)
	get_parent().move_child(_new, get_parent().get_child_count()-1)
	
	_new.position = self.position
	_new.set_direction(look_direction)
