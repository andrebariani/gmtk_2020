extends Area2D

var pressed = false
var active = true

onready var instrument = get_child(5)

export var text = "G"
export var key = KEY_L

var slot = null
var target = null
var action = -1

signal assigned
signal current

func _ready():
	$Label.text = text

func _process(_delta):
	if pressed and active:
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
	instrument.volume_db = 0
	$attach.play(0)
	print_debug("Set " + str(_slot.get_action()))


func clear_slot(_old_slot):
	if slot == _old_slot:
		slot = null
		action = -1
		target = null
		_old_slot.set_button(null)
		instrument.volume_db = -80
		$dettach.play(0)
		print_debug("Clear " + str(_old_slot.get_action()))


func _on_Button_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		pressed = event.pressed
		
		if pressed:
			emit_signal("current", self.name)
			get_parent().move_child(self, get_parent().get_child_count()-1)
			
		elif !pressed and action != -1:
			emit_signal("assigned", key, action)


func set_active(_new):
	active = _new


func get_key():
	return key


func _on_Button_area_entered(area):
	if area.get_button() == null:
		set_slot(area)


func _on_Button_area_exited(area):
	if area.get_button() == self and !area.get_mouseover():
		clear_slot(area)
