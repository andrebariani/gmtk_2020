extends Area2D

var focused = false
var button = null

export var action = 0

func get_action():
	return action


func _on_ActionSlot_area_entered(area):
	if area.has_method("set_target"):
		area.set_target(self)
		button = area


func _on_ActionSlot_area_exited(area):
	if area.has_method("set_target"):
		area.set_target(null)
		button = null
