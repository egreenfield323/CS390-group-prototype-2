extends Node
# Based on https://github.com/godotengine/godot-proposals/issues/2526

func _init():
	if !OS.has_feature("web_ios") and !OS.has_feature("web_android"):
		return
	JavaScriptBridge.eval("""
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

func get_accelerometer() -> Vector3:
	if !OS.has_feature('JavaScript'): return Input.get_accelerometer()
	
	var x = JavaScriptBridge.eval('acceleration.x')
	var y = JavaScriptBridge.eval('acceleration.y')
	var z = JavaScriptBridge.eval('acceleration.z')
	
	return Vector3(x, y, z)


func supports_js() -> bool:
	return OS.has_feature("web_ios") or OS.has_feature("web_android")
