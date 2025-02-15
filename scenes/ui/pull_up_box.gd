extends VBoxContainer

signal pull_up_event_complete
signal pull_up_event_failed


var running := false : set = _set_running

var accumulated_time := 0.0 : set = _set_accumulated_time
var current_event_time := 1.0 : set = _set_current_event_time


func _ready() -> void:
	process_mode = ProcessMode.PROCESS_MODE_DISABLED


func start_pull_up_event(time: float) -> void:
	current_event_time = time
	accumulated_time = 0.0
	WebInput.hook_set.connect(_on_pulled_up)
	WebInput.start_bite()
	running = true


func stop_pull_up_event() -> void:
	WebInput.stop_bite()
	if WebInput.hook_set.is_connected(_on_pulled_up):
		WebInput.hook_set.disconnect(_on_pulled_up)
	running = false


func _process(delta: float) -> void:
	accumulated_time += delta
	if accumulated_time >= current_event_time:
		pull_up_event_failed.emit()


func _on_pulled_up() -> void:
	stop_pull_up_event()
	pull_up_event_complete.emit()


func _set_running(new_running: bool) -> void:
	running = new_running
	visible = running
	process_mode = (
		ProcessMode.PROCESS_MODE_INHERIT
		if running else
		ProcessMode.PROCESS_MODE_DISABLED
	)


func _set_accumulated_time(new_accumulated_time: float) -> void:
	accumulated_time = new_accumulated_time
	$ProgressBar.value = accumulated_time


func _set_current_event_time(new_current_event_time: float) -> void:
	current_event_time = new_current_event_time
	$ProgressBar.max_value = current_event_time
