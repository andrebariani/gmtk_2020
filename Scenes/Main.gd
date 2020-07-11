extends Node2D

var buttons = ["G", "H", "J", "F"]


func send_input_system(key, action):
	$Game.send_input_system(key, action)


func _on_Game_player_damaged():
	var rando = randi() % buttons.size()
	
	var node = get_node(buttons[rando])
	
	send_input_system(node.get_key(), null)
	node.queue_free()
	buttons.remove(rando)
	
	if buttons.size() <= 0:
		out_of_control()


func out_of_control():
	pass
