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


func _on_cast_button_button_up() -> void:
	var cast_distance = WebInput.stop_cast()
	
	var cast_accel = inverse_lerp(0, 120, cast_distance)
	var casting_level = lerp(0, 10, cast_accel)
	
	$VBox/CastDistance.text = "Cast distance level: " + str(int(casting_level))


func _on_request_motion_pressed() -> void:
	WebInput.request_access()
