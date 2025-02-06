extends Node
# Based on https://github.com/godotengine/godot-proposals/issues/2526

var current_cast_max_acceleration := 0.0
var casting := false


func _process(delta: float) -> void:
	if not casting:
		return
	
	var acceleration := get_accelerometer()
	
	current_cast_max_acceleration = max(
		acceleration,
		current_cast_max_acceleration
	)


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
	casting = true


func stop_cast() -> float:
	casting = false
	return current_cast_max_acceleration
