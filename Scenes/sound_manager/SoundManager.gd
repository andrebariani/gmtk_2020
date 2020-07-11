extends Node

signal current_changed(name)

onready var songs_list = $songs
onready var sfx_list = $sfx

# Songs and sound effects dictionary is populated at _ready()
var songs = { }
var sfx = { }

# Current stream playing
var current: AudioStreamPlayer
# Auxiliary stream to play, used for fade effects and vertical mixing
var next: AudioStreamPlayer


# Loads all audio streams available at songs and sfx nodes
func _ready():
	for s in songs_list.get_children():
		songs[str(s.name)] = s
	for s in sfx_list.get_children():
		sfx[str(s.name)] = s


# Stops playing audio streams
func stop():
	current.stop()
	play_dual_stop()


# Play stream by the name and where to begin playing by seconds 
func play(name: String, from: float = 0.0):
	$TweenFadeIn.stop_all()
	
	if songs[name]:
		if next: next.stop()
		next = songs[name]
		
		# Do not start the same song again
		if current && next.name == current.name: return
		if current: current.stop()
		
		current = next
		
		emit_signal("current_changed", current.name)
		current.play(from)
	else:
		print_debug("Song \'" + name + "\' not found")


# Fade-out current stream and set next stream to play
func play_with_fade_in(name: String, duration: float = 0.0):
	$TweenFadeIn.stop_all()
	
	if songs[name]:
		next = songs[name]
		
		# Do not start the same stream again
		if current && next.name == current.name: return
		
		$TweenFadeIn.interpolate_method(current, "set_volume_db",
			current.get_volume_db(), -80, duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$TweenFadeIn.start()
	else:
		print_debug("Song \'" + name + "\' not found")


func _on_TweenFadeIn_tween_completed(object, key):
	object.stop()
	object.set_volume_db(0)
	
	current = next
	emit_signal("current_changed", current.name)
	current.play()


# Fade-out current stream and fade-in next stream
func play_with_cross_fade(name: String, duration: float = 0.0):
	if songs[name]:
		next = songs[name]
		
		# Do not start the same stream again
		if current && next.name == current.name: return
		
		$TweenCrossCurr.interpolate_method(current, "set_volume_db",
			current.get_volume_db(), -20, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration)
		$TweenCrossNext.interpolate_method(next, "set_volume_db",
			-20, 0, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$TweenCrossCurr.start()
		$TweenCrossNext.start()
		
		next.play()
	else:
		print_debug("Song \'" + name + "\' not found")


func _on_TweenCrossCurr_tween_completed(object, key):
	current.stop()
	current.set_volume_db(0)
	
	current = next
	emit_signal("current_changed", current.name)


# Pause current stream to play new stream
func play_fanfare(name: String):
	$TweenFadeIn.stop_all()
	
	if songs[name]:
		next = songs[name]
		
		next.connect("finished", self, "_on_fanfare_finished")
		
		current.stream_paused = true
		next.play()
		emit_signal("current_changed", next.name)
	else:
		print_debug("Fanfare \'" + name + "\' not found")
		pass


func _on_fanfare_finished():
	next.stop()
	current.stream_paused = false
	emit_signal("current_changed", current.name)
	next.disconnect("finished", self, "_on_fanfare_finished")


# Play main stream, prepare second stream to play
func play_dual(main: String, second: String):
	self.play(main)
	next = songs[second]
	next.set_volume_db(-80)


# Play setted second stream
func play_dual_start():
	next.set_volume_db(0)
	next.play(current.get_playback_position())


# Stop setted second stream
func play_dual_stop():
	next.set_volume_db(-80)
	next.stop()


func play_sfx(name: String):
	if sfx[name]:
		sfx[name].play()
	else:
		print_debug("Sfx \'" + name + "\' not found")
