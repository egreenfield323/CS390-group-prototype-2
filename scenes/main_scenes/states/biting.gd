extends State

const MIN_BITE_TIME = 2.5
const MAX_BITE_TIME = 5.0

var timer: Timer = null


func enter() -> void:
	state_machine.game.trigger_bite()
	timer = Timer.new()
	timer.one_shot = true
	process_mode = PROCESS_MODE_INHERIT
	add_child(timer)
	timer.timeout.connect(_bite_timeout)
	_begin_bite_timer()
	WebInput.hook_set.connect(_on_hook_set)
	WebInput.start_bite()


func exit() -> void:
	timer.queue_free()
	WebInput.hook_set.disconnect(_on_hook_set)
	process_mode = PROCESS_MODE_DISABLED


func _begin_bite_timer() -> void:
	var time := randf_range(MIN_BITE_TIME, MAX_BITE_TIME)
	
	timer.wait_time = time
	timer.start()


func _bite_timeout() -> void:
	WebInput.stop_bite()
	state_machine.change_state_to(Game.States.AWAITING_BITE)


func _on_hook_set() -> void:
	state_machine.change_state_to(Game.States.FISH_HOOKED)
