extends Node2D

export var move_speed = 100
var direction = Vector2(0, 1)


func _process(delta):
	self.position += direction*move_speed*delta


func set_direction(_direction):
	direction = _direction
	self.rotation_degrees = int(direction.x==1)*90 + int(direction.x==-1)*270 + int(direction.y==1)*180 + int(direction.y==-1)*0


func _on_Area2D_area_entered(area):
	if area.has_method("destroy"):
		area.destroy()
	
	queue_free()
