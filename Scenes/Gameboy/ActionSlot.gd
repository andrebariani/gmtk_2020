extends Area2D

var button = null
var mouseover = false

export var action = 0

func get_action():
	return action


func get_button():
	return button


func get_mouseover():
	return mouseover


func set_button(_new):
	button = _new


func _on_ActionSlot_mouse_entered():
	mouseover = true


func _on_ActionSlot_mouse_exited():
	mouseover = false
