extends "res://Scenes/Item/Item.gd"

func _on_Area2D_area_entered(area):
	if area.has_method("gotten_fuel"):
		area.gotten_fuel()
	
	destroy()
