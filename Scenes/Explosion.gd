extends Node2D

func _on_Area2D_area_entered(area):
	if area.has_method("destroy"):
		area.destroy()
