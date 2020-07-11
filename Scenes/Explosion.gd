extends Node2D

var scaler = 0.1

func _process(delta):
	scaler += 50*delta
	if scaler > 30:
		queue_free()
	else:
		self.scale = Vector2(scaler, scaler)


func _on_Area2D_area_entered(area):
	if area.has_method("destroy"):
		area.destroy()
