extends Node
class_name SoundBank

@export var identifiers: Array[String] = []
@export var streams: Array[AudioStream] = []

# identifier (String): AudioStreamPlayer
var looping: Dictionary = {}


func play(identifier: String) -> void:
	if not identifier in identifiers:
		push_warning("Couldn't find sound " + identifier)
		return
	
	var stream := streams[identifiers.find(identifier)]
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.finished.connect(
		func():
			player.queue_free()
	)
	add_child(player)
	player.play()


func play_looping(identifier: String) -> void:
	if not identifier in identifiers:
		push_warning("Couldn't find sound " + identifier)
		return
	
	if identifier in looping.keys():
		return # Already looping
	
	var stream := streams[identifiers.find(identifier)]
	var player := AudioStreamPlayer.new()
	player.stream = stream
	add_child(player)
	player.play()
	looping[identifier] = player


func stop_looping(identifier: String) -> void:
	if not identifier in looping.keys():
		return
	
	looping[identifier].queue_free()
	looping.erase(identifier)
