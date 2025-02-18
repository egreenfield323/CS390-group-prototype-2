extends Button
class_name SoundButton

const BUTTON_PRESSED = "button_click"


func _ready() -> void:
	pressed.connect(
		func():
			UISoundBank.play(BUTTON_PRESSED)
	)
