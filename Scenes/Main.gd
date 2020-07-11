extends Node2D

var buttons = ["Button"]


func send_input_system(key, action):
	$Game.send_input_system(key, action)


func _on_Game_player_damaged():
	var rando = randi() % buttons.size()
	
	get_node(buttons[rando]).queue_free()
	buttons.remove(rando)
	
	if buttons.size() <= 0:
		out_of_control()


func out_of_control():
	pass
