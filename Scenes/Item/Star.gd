extends "res://Scenes/Item/Item.gd"

func _on_Area2D_area_entered(area):
	if area.has_method("score"):
		area.score()
		
		$AudioStreamPlayer.play(0)
		$Area2D/CollisionShape2D.disabled = true
		self.visible = false
	else:
		destroy()


func _on_AudioStreamPlayer_finished():
	destroy()
