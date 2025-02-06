extends Control

const ACCELEROMETER_TEXT = "Acellerometer: X: %f, Y: %f, Z: %f"
const SUPPORT_TEXT = "JavaScript support: %s"


func _ready() -> void:
	$VBox/Support.text = SUPPORT_TEXT % WebInput.supports_js()

func _process(delta: float) -> void:
	var data := WebInput.get_accelerometer()
	$VBox/Acellerometer.text = ACCELEROMETER_TEXT % [data.x, data.y, data.z]


func _on_cast_button_button_down() -> void:
	WebInput.start_cast()
	
	pass

func _on_cast_button_button_up() -> void:
	var cast_distance = WebInput.stop_cast()
	$VBox/CastDistance.text = "Cast distance: " + str(cast_distance)
	
	pass
