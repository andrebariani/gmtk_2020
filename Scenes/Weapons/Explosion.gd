extends Node2D

var timer = 0

func _process(delta):
	timer += delta
	if timer > 0.5:
		queue_free()


func _on_Area2D_area_entered(area):
	if area.has_method("destroy"):
		area.destroy()
