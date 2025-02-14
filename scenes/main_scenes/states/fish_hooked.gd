extends State

# In tension/second
# Use these when fish difficulty can influence this state.
#const TENSION_MIN_INCREASE_RATE = 25
#const TENSION_MAX_INCREASE_RATE = 75
#const TENSION_MIN_DECREASE_RATE = 15
#const TENSION_MAX_DECREASE_RATE = 50

const TENSION_INCREASE_RATE = 50
const TENSION_DECREASE_RATE = 33

# distance/second
const REEL_SPEED = 5.0

var reeling := false


# Put gameplay logic for reaction events and/or reeling here.
func enter() -> void:
	reeling = false
	state_machine.game.enable_reeling()
	state_machine.game.ui.start_reeling.connect(_start_reeling)
	state_machine.game.ui.stop_reeling.connect(_stop_reeling)
	process_mode = ProcessMode.PROCESS_MODE_INHERIT


func _process(delta: float) -> void:
	if reeling:
		state_machine.game.line_tension += TENSION_INCREASE_RATE * delta
		state_machine.game.bobber_distance -= REEL_SPEED * delta
		if state_machine.game.bobber_distance <= 0.0:
			_on_fish_caught()
		if state_machine.game.line_tension >= Game.MAX_LINE_TENSION:
			_on_line_too_tight()
	else:
		state_machine.game.line_tension -= TENSION_DECREASE_RATE * delta
		if state_machine.game.line_tension <= 0.0:
			_on_line_too_loose()


func exit() -> void:
	state_machine.game.disable_reeling()
	state_machine.game.ui.start_reeling.disconnect(_start_reeling)
	state_machine.game.ui.stop_reeling.disconnect(_stop_reeling)
	process_mode = ProcessMode.PROCESS_MODE_DISABLED


func _on_line_too_tight() -> void:
	state_machine.change_state_to(Game.States.CASTING)


func _on_line_too_loose() -> void:
	state_machine.change_state_to(Game.States.CASTING)


func _on_fish_caught() -> void:
	state_machine.change_state_to(Game.States.SHOWING_REWARD)


func _start_reeling() -> void:
	reeling = true


func _stop_reeling() -> void:
	reeling = false
