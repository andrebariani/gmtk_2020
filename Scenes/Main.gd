extends Node2D

var buttons = ["W", "A", "S"]
var how_to_play = false

func set_current_button(current):
	for button in buttons:
		get_node(button).set_active(button == current)


func send_input_system(key, action):
	$Game.send_input_system(key, action)
	if is_instance_valid($Menu):
		$Menu.receive_input(key, action)
		$AnimationPlayer.play("bye_manual")
		
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
	$drums.stop()


func _on_Start_button_up():
	get_tree().reload_current_scene()


func _on_Menu_play():
	$Game.start()


func _on_HowToPlay_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		how_to_play = !how_to_play
		
		if how_to_play:
			$AnimationPlayer.play("how_to_play")
		else:
			$AnimationPlayer.play_backwards("how_to_play")

func show_how_to_play(_show):
	if _show:
		move_child($HowToPlay, get_child_count()-1)
	else:
		move_child($HowToPlay, 2)

func _on_HowToPlay_mouse_entered():
	$HowToPlay.color = Color("ffe596")


func _on_HowToPlay_mouse_exited():
	$HowToPlay.color = Color("fcf960")
