extends Area2D

var button = null

export var action = 0

func get_action():
	return action


func _on_ActionSlot_area_entered(area):
	if area.has_method("set_slot") and button == null:
		area.set_slot(self)


func _on_ActionSlot_area_exited(area):
	if area.has_method("clear_slot") and button == area:
		area.clear_slot(self)


func get_button():
	return button


func set_button(_new):
	button = _new
