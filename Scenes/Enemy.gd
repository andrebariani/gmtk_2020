extends Node2D

export var move_speed = 3
var direction = 1


func _process(delta):
	self.position.x += direction*move_speed*delta


func set_direction(_direction):
	direction = _direction


func _on_Area2D_area_entered(area):
	if area.has_method("damaged"):
		area.damaged()
	
	queue_free()
