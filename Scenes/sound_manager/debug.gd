extends Control

onready var sound_manager = get_tree().get_nodes_in_group("sound_manager").front()
onready var songs_list = get_parent().get_child(0)
onready var sfx_list = get_parent().get_child(1)

func _ready():
	sound_manager.connect("current_changed", self, "_on_current_changed")
	
	for s in songs_list.get_children():
		$SongSelect.add_item(s.name)
		$SongSelect2.add_item(s.name)
		
	for e in sfx_list.get_children():
		$SfxSelect.add_item(e.name)
		
	$FadeSelect.add_item("play")
	$FadeSelect.add_item("play_with_fade_in")
	$FadeSelect.add_item("play_with_cross_fade")
	$FadeSelect.add_item("play_fanfare")
	$FadeSelect.add_item("play_dual")
	$FadeSelect.add_item("play_dual_start")
	$FadeSelect.add_item("play_dual_stop")
	


func _physics_process(delta):
	if sound_manager.current:
		$current.set_text("current vol: " + str(sound_manager.current.volume_db))
	if sound_manager.next:
		$next.set_text("next vol: " + str(sound_manager.next.volume_db))


func _on_Button_pressed():
	match $FadeSelect.selected:
		0: sound_manager.play($SongSelect.get_item_text($SongSelect.selected))
		1: sound_manager.play_with_fade_in($SongSelect.get_item_text($SongSelect.selected), 2)
		2: sound_manager.play_with_cross_fade($SongSelect.get_item_text($SongSelect.selected), 0.5)
		3: sound_manager.play_fanfare($SongSelect.get_item_text($SongSelect.selected))
		4: sound_manager.play_dual($SongSelect.get_item_text($SongSelect.selected), $SongSelect2.get_item_text($SongSelect2.selected))
		5: sound_manager.play_dual_start()
		6: sound_manager.play_dual_stop()


func _on_current_changed(current_name: String):
	for i in range(0, $SongSelect.get_item_count()):
		if $SongSelect.get_item_text(i) == current_name:
			$SongSelect.select(i)
			return


func _on_SfxSelect_item_selected(id):
	sound_manager.play_sfx($SfxSelect.get_item_text(id))
