extends Node2D

export var move_speed = 3
var direction = 1
export(PackedScene) var death

func _ready():
	$Ship.animate("move")

func _process(delta):
	self.position.x += direction*move_speed*delta


func set_direction(_direction):
	direction = _direction
	if direction == 1:
		self.rotation_degrees = 180


func _on_Area2D_area_entered(area):
	if area.has_method("damaged"):
		area.damaged()
	
	destroy()

func destroy():
	var _new = death.instance()
	get_parent().add_child(_new)
	get_parent().move_child(_new, get_parent().get_child_count()-3)
	_new.global_position = self.global_position
	queue_free()
