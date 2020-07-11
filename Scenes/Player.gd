extends Node2D

export(PackedScene) var bullet
export(PackedScene) var explosion_scene

export var dash_distance = 100
export var move_speed = 5
onready var target_y = self.position.y
var moving = false

var shoot_clock = 0

var controls = {KEY_F:-1, KEY_G:-1, KEY_H:-1, KEY_J:-1}

var inv_frames = 0
var paused = true

var explosions = 3

signal damaged
signal scored
signal exploded
signal gotten_fuel
signal dash_distance

func _ready():
	emit_signal("dash_distance", dash_distance)


func _process(delta):
	if inv_frames > 0:
		inv_frames -= delta
	if shoot_clock > 0:
		shoot_clock -= delta
	
	var distance = target_y
	
	if distance > 2:
		distance = 1
	elif distance < -2:
		print_debug(distance)
		distance = -1
	else:
		if moving:
			moving = false
		else:
			$Ship.animate("idle")
		return
	
	moving = true
	distance = move_speed*delta*distance
	self.position.y += (distance + int(self.position.y >= 610)*(-600) + 
		int(self.position.y <= -10)*600)
	target_y -= distance
	


func receive_input(key, action):
	controls[key] = action


func _input(event):
	if paused:
		return
	
	if event is InputEventKey and event.pressed and event.scancode in controls:
		var input = controls[event.scancode]
		match(input):
			0: # UP
				if !moving:
					dash(-1)
					self.rotation_degrees = 90
					$Ship.animate("move")
			1: # DOWN
				if !moving:
					dash(1)
					self.rotation_degrees = 270
					$Ship.animate("move")
			2: # LEFT
				self.rotation_degrees = 0
				if shoot_clock <= 0:
					shoot_clock = 0.2
					shoot(Vector2(-1, 0))
			3: # RIGHT
				self.rotation_degrees = 180
				if shoot_clock <= 0:
					shoot_clock = 0.2
					shoot(Vector2(1, 0))
			4: # SHOOT UP+DOWN
				if shoot_clock <= 0:
					shoot_clock = 0.2
					shoot(Vector2(0, -1))
					shoot(Vector2(0, 1))
			5: # EXPLOSION
				explosion()


func damaged():
	if inv_frames <= 0:
		$Ship.animate("blink")
		emit_signal("damaged")
		inv_frames = 2


func gotten_fuel():
	if explosions >= 3:
		return
	emit_signal("gotten_fuel", explosions)
	explosions += 1


func score():
	emit_signal("scored")


func dash(direction):
	target_y = (direction * dash_distance)


func shoot(direction):
	var _new = bullet.instance()
	get_parent().add_child(_new)
	get_parent().move_child(_new, get_parent().get_child_count()-3)
	
	_new.global_position = int(direction.x!=0)*$Shoot.global_position + int(direction.x==0)*self.global_position
	_new.set_direction(direction)


func explosion():
	if explosions <= 0:
		return
	
	explosions -= 1
	var _new = explosion_scene.instance()
	get_parent().add_child(_new)
	get_parent().move_child(_new, get_parent().get_child_count()-3)
	_new.position = self.position
	emit_signal("exploded", explosions)
