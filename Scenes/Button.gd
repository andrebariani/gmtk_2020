extends Area2D


func _on_Button_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_action_pressed():
		self.global_position =  get_global_mouse_position()
