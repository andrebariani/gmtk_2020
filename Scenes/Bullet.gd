extends Node2D

export var move_speed = 100
var direction = 1


func _process(delta):
	self.position.x += direction*move_speed*delta


func set_direction(_direction):
	direction = _direction
