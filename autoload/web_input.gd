extends Node
# Based on https://github.com/godotengine/godot-proposals/issues/2526

signal flags_updated(flags)

var _js_callback = JavaScriptBridge.create_callback(func(args): flags_updated.emit(args))
func _init():
	if !supports_js():
		return
	#JavaScriptBridge.eval("""
		#var acceleration = { x: 0, y: 0, z: 0 }
#
		#function registerMotionListener() {
			#window.ondevicemotion = function(event) {
				#if (event.acceleration.x === null) return
				#acceleration.x = event.acceleration.x
				#acceleration.y = event.acceleration.y
				#acceleration.z = event.acceleration.z
			#}
		#}
#
		#if (typeof DeviceOrientationEvent.requestPermission === 'function') {
			#DeviceOrientationEvent.requestPermission().then(function(state) {
				#if (state === 'granted') registerMotionListener()
			#})
		#}
		#else {
			#registerMotionListener()
		#}
	#""", true)
	var orientation = JavaScriptBridge.get_interface("DeviceOrientationEvent")
	orientation.then(_js_callback)


func register_accelerometer_listener() -> void:
	var window = JavaScriptBridge.get_interface("window")
	window.ondevicemotion = _js_callback


func get_accelerometer() -> Vector3:
	if !supports_js(): return Input.get_accelerometer()
	
	var x = JavaScriptBridge.eval('acceleration.x')
	var y = JavaScriptBridge.eval('acceleration.y')
	var z = JavaScriptBridge.eval('acceleration.z')
	
	return Vector3(x, y, z)


func supports_js() -> bool:
	return OS.has_feature("web_ios") or OS.has_feature("web_android")


func try_permission() -> String:
	if !supports_js():
		return "JS not supported."
	else:
		return JavaScriptBridge.eval("typeof DeviceOrientationEvent.requestPermission")
