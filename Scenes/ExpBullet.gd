extends "res://Scenes/Bullet.gd"

export(PackedScene) var explosion

func _on_Area2D_area_entered(area):
	if area.has_method("destroy"):
		area.destroy()
	
	var _new = explosion.instance()
	get_parent().add_child(_new)
	get_parent().move_child(_new, get_parent().get_child_count()-1)
	_new.position = self.position
	
	queue_free()
