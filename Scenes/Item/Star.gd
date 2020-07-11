extends "res://Scenes/Item/Item.gd"

func _on_Area2D_area_entered(area):
	if area.has_method("score"):
		area.score()
	
	destroy()
