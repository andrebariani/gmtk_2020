extends Area2D

var pressed = false
var target = null

export var key = KEY_L
var action = null

signal assigned

func _process(delta):
	if pressed:
		self.global_position =  get_global_mouse_position()
	elif target != null:
		self.position = self.position*0.9 + target*0.1


func set_target(_sensei):
	if _sensei == null:
		action = null
		target = null
	else:
		action = _sensei.get_action()
		target = _sensei.position


func _on_Button_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		pressed = event.pressed
		
		if !pressed:
			emit_signal("assigned", key, action)
