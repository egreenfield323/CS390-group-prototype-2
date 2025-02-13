extends Node
# Based on https://github.com/godotengine/godot-proposals/issues/2526

signal hook_set

const MIN_SET_HOOK_ACCELERATION = 10.0

var current_cast_max_acceleration := 0.0
var forced_cast_max_acceleration := -1.0
var casting := false
var biting := false


func _ready() -> void:
	if DevInputs.ENABLED:
		DevInputs.force_cast_acceleration.connect(
			func(value: float):
				forced_cast_max_acceleration = value
		)
		DevInputs.force_set_hook.connect(_on_player_set_hook)


func _process(_delta: float) -> void:
	var acceleration := get_accelerometer()
	if casting:
		current_cast_max_acceleration = max(
			acceleration.length(),
			current_cast_max_acceleration
		)
	
	if biting:
		if acceleration.length() >= MIN_SET_HOOK_ACCELERATION:
			_on_player_set_hook()


func request_access() -> void:
	JavaScriptBridge.eval(
	"""
		var acceleration = { x: 0, y: 0, z: 0 }

		function registerMotionListener() {
			window.ondevicemotion = function(event) {
				if (event.acceleration.x === null) return
				acceleration.x = event.acceleration.x
				acceleration.y = event.acceleration.y
				acceleration.z = event.acceleration.z
			}
		}

		if (typeof DeviceOrientationEvent.requestPermission === 'function') {
			DeviceOrientationEvent.requestPermission().then(function(state) {
				if (state === 'granted') registerMotionListener()
			})
		}
		else {
			registerMotionListener()
		}
	""", true)
	return str("running...")


func get_accelerometer() -> Vector3:
	if !supports_js(): return Input.get_accelerometer()
	
	var x = JavaScriptBridge.eval('acceleration.x')
	var y = JavaScriptBridge.eval('acceleration.y')
	var z = JavaScriptBridge.eval('acceleration.z')
	
	return Vector3(x, y, z)


func supports_js() -> bool:
	return OS.has_feature("web_ios") or OS.has_feature("web_android")


func start_cast() -> void:
	current_cast_max_acceleration = 0.0
	casting = true


func stop_cast() -> float:
	casting = false
	
	if not forced_cast_max_acceleration == -1.0:
		return forced_cast_max_acceleration
	
	return current_cast_max_acceleration


func _on_player_set_hook() -> void:
	hook_set.emit()
	stop_bite()


func start_bite() -> void:
	biting = true


func stop_bite() -> void:
	biting = false
