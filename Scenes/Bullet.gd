extends Node2D

export var move_speed = 100
var direction = Vector2(0, 1)


func _process(delta):
	self.position += direction*move_speed*delta


func set_direction(_direction):
	direction = _direction


func _on_Area2D_area_entered(area):
	if area.has_method("destroy"):
		area.destroy()
	
	queue_free()
