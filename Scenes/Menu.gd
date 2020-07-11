extends Node2D

var controls = {KEY_F:-1, KEY_G:-1, KEY_H:-1, KEY_J:-1}
var option = 0

onready var options = [$Menu/Play, $Menu/Credits, $Menu/Quit, $Credits/Back]

signal play

func receive_input(key, action):
	controls[key] = action


func _input(event):
	if event is InputEventKey and event.pressed and event.scancode in controls:
		var input = controls[event.scancode]
		match(input):
			0: # UP
				if option == 0:
					set_option(2)
				elif option > 0 and option < 3:
					set_option(option-1)
			1: # DOWN
				if option == 2:
					set_option(0)
				elif option < 2:
					set_option(option+1)
			2, 3, 4, 5: # SELECT
				match(option):
					0:
						play()
					1:
						set_option(3)
						credits(true)
					2:
						quit()
					3:
						set_option(1)
						credits(false)


func set_option(_new):
	options[option].set("custom_colors/font_color", Color("346856"))
	option = _new
	options[option].set("custom_colors/font_color", Color("081820"))


func play():
	emit_signal("play")
	queue_free()


func credits(open):
	if open:
		$AnimationPlayer.play("credits")
	else:
		$AnimationPlayer.play("menu")


func quit():
	get_tree().quit()
