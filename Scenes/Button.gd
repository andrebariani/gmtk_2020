extends Area2D

var pressed = false

export var text = "G"
export var key = KEY_L

var slot = null
var target = null
var action = -1

signal assigned

func _ready():
	$Label.text = text

func _process(delta):
	if pressed:
		self.global_position = get_global_mouse_position()
	elif target != null:
		self.global_position = self.global_position*0.9 + target*0.1


func set_slot(_slot):
	if slot != null:
		slot.set_button(null)
	slot = _slot
	action = _slot.get_action()
	target = _slot.global_position
	_slot.set_button(self)


func clear_slot(_slot):
	if slot == _slot:
		slot = null
		action = -1
		target = null
		_slot.set_button(null)


func _on_Button_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		pressed = event.pressed
		
		if pressed:
			get_parent().move_child(self, get_parent().get_child_count()-1)
		elif !pressed and action != null:
			emit_signal("assigned", key, action)


func get_key():
	return key
