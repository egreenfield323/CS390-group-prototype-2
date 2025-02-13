extends AudioStreamPlayer

# This script can later be extended to enable things such as fading between tracks. The benefit of
# using a singleton here is that scene changes won't impact the music.

const MUSIC = preload("res://assets/music/underwater.wav")


func _ready() -> void:
	stream = MUSIC
	play()
