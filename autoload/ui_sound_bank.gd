extends SoundBank
# This class is intended to prevent UI sounds being cut off when changing scene.

const IDENTIFIERS: Array[String] = [
	"button_click"
]

const STREAMS: Array[AudioStream] = [
	preload("res://assets/sound/button_click.wav")
]


func _ready() -> void:
	identifiers = IDENTIFIERS
	streams = STREAMS
