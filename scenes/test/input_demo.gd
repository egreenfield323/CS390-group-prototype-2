extends Control

const ACCELEROMETER_TEXT = "Acellerometer: X: %f, Y: %f, Z: %f"
const SUPPORT_TEXT = "JavaScript support: %s"


func _ready() -> void:
	WebInput.flags_updated.connect(
		func(args):
			$VBox/UserAgent.text = str(args)
	)
	WebInput.try_permission()
	$VBox/Support.text = SUPPORT_TEXT % WebInput.supports_js()

func _process(delta: float) -> void:
	var data := WebInput.get_accelerometer()
	$VBox/Acellerometer.text = ACCELEROMETER_TEXT % [data.x, data.y, data.z]

func _on_execute_pressed() -> void:
	$VBox/Console.text = str(JavaScriptBridge.eval($VBox/Console.text))
