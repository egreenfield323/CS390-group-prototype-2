extends CanvasLayer

signal force_cast_acceleration(value: float)
signal force_set_hook

const ENABLED = true
const TOGGLE_DEV_INPUTS = "toggle_dev_inputs"
const QUICK_SET_HOOK = "quick_dev_set_hook"


func _ready() -> void:
	hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(TOGGLE_DEV_INPUTS):
		visible = !visible
	if event.is_action_pressed(QUICK_SET_HOOK):
		_set_hook_pressed()


func _cast_acceleration_updated(value: float) -> void:
	force_cast_acceleration.emit(value)


func _set_hook_pressed() -> void:
	force_set_hook.emit()
