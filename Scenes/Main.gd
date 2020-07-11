extends Node2D

var buttons = ["F", "G", "H", "J",]

func set_current_button(current):
	for button in buttons:
		get_node(button).set_active(button == current)


func send_input_system(key, action):
	$Game.send_input_system(key, action)
	for button in buttons:
		get_node(button).set_active(true)


func _on_Game_player_damaged():
	if buttons.size() <= 0:
		return
	
	var rando = randi() % buttons.size()
	
	var node = get_node(buttons[rando])
	
	send_input_system(node.get_key(), null)
	node.queue_free()
	buttons.remove(rando)
	
	if buttons.size() <= 0:
		out_of_control()


func out_of_control():
	$Shutdown/Score.text = "SCORE:" + str($Game.get_score())
	$AnimationPlayer.play("out_of_control")
