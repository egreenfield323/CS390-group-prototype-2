extends Control

const ACCELEROMETER_TEXT = "Acellerometer: X: %f, Y: %f, Z: %f"
const SUPPORT_TEXT = "JavaScript support: %s"


func _ready() -> void:
	$VBox/Support.text = SUPPORT_TEXT % WebInput.supports_js()

func _process(_delta: float) -> void:
	var data := WebInput.get_accelerometer()
	$VBox/Acellerometer.text = ACCELEROMETER_TEXT % [data.x, data.y, data.z]


func _on_cast_button_button_down() -> void:
	WebInput.start_cast()


func _on_cast_button_button_up() -> void:
	var cast_distance = WebInput.stop_cast()
	$VBox/CastDistance.text = "Cast distance: " + str(cast_distance)


func _on_request_motion_pressed() -> void:
	WebInput.request_access()


func _on_start_bite_pressed() -> void:
	WebInput.hook_set.connect(_on_hook_set)
	WebInput.start_bite()
	$BiteAnimation.play("biting")


func _on_stop_bite_pressed() -> void:
	WebInput.stop_bite()
	WebInput.hook_set.disconnect(_on_hook_set)
	$BiteAnimation.play("no_bite")


func _on_hook_set() -> void:
	WebInput.hook_set.disconnect(_on_hook_set)
	$BiteAnimation.animation_finished.connect(_on_animation_finished)
	$BiteAnimation.play("hook_set")


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "hook_set":
		$BiteAnimation.play("no_bite")
		$BiteAnimation.animation_finished.disconnect(_on_animation_finished)
