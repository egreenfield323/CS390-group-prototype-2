extends Control

const ACCELEROMETER_TEXT = "Acellerometer: X: %f, Y: %f, Z: %f"
const SUPPORT_TEXT = "JavaScript support: %s"

func _process(delta: float) -> void:
	var data := WebInput.get_accelerometer()
	$VBox/Acellerometer.text = ACCELEROMETER_TEXT % [data.x, data.y, data.z]
	$VBox/Support.text = SUPPORT_TEXT % WebInput.supports_js()
