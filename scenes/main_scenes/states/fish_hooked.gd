extends State

# In tension/second
# Use these when fish difficulty can influence this state.
const TENSION_MIN_INCREASE_RATE = 25.0
const TENSION_MAX_INCREASE_RATE = 100.0
const TENSION_MIN_DECREASE_RATE = 15.0
const TENSION_MAX_DECREASE_RATE = 75.0

# Seconds the user will have to pull up on a pull up event. Will be randomly
# selected between a lower and upper bound dependant on difficulty. Lower is
# harder.
const MIN_PULL_UP_LOWER_BOUND = 0.5
const MAX_PULL_UP_LOWER_BOUND = 3.0
const MIN_PULL_UP_UPPER_BOUND = 1.0
const MAX_PULL_UP_UPPER_BOUND = 5.0

# Seconds of cooldown before the game can serve the player another pull up
# event. Lower and upper bound work similarly to the above constants.
const MIN_PULL_UP_COOLDOWN_LOWER_BOUND = 1.0
const MAX_PULL_UP_COOLDOWN_LOWER_BOUND = 3.0
const MIN_PULL_UP_COOLDOWN_UPPER_BOUND = 1.5
const MAX_PULL_UP_COOLDOWN_UPPER_BOUND = 5.0

# distance/second
const REEL_SPEED = 6.5

var reeling := false

var tension_increase_rate := TENSION_MIN_INCREASE_RATE
var tension_decrease_rate := TENSION_MIN_DECREASE_RATE

var pull_up_lower_bound := MIN_PULL_UP_LOWER_BOUND
var pull_up_upper_bound := MIN_PULL_UP_UPPER_BOUND

var pull_up_cooldown_lower_bound := MIN_PULL_UP_COOLDOWN_LOWER_BOUND
var pull_up_cooldown_upper_bound := MIN_PULL_UP_COOLDOWN_UPPER_BOUND

var cooldown_timer: Timer = null


# Put gameplay logic for reaction events and/or reeling here.
func enter() -> void:
	state_machine.game.select_fish()
	_pick_game_parameters(
		state_machine.game.hooked_fish.difficulty
	)
	_make_timer()
	_start_cooldown_timer()
	reeling = false
	state_machine.game.enable_reeling()
	state_machine.game.ui.start_reeling.connect(_start_reeling)
	state_machine.game.ui.stop_reeling.connect(_stop_reeling)
	state_machine.game.ui.pull_up_event_completed.connect(_pull_up_completed)
	state_machine.game.ui.pull_up_event_failed.connect(_pull_up_failed)
	process_mode = ProcessMode.PROCESS_MODE_INHERIT


func _process(delta: float) -> void:
	if reeling:
		state_machine.game.line_tension += tension_increase_rate * delta
		state_machine.game.bobber_distance -= REEL_SPEED * delta
		if state_machine.game.bobber_distance <= 0.0:
			_on_fish_caught()
		if state_machine.game.line_tension >= Game.MAX_LINE_TENSION:
			_on_line_too_tight()
	else:
		state_machine.game.line_tension -= tension_decrease_rate * delta
		if state_machine.game.line_tension <= 0.0:
			_on_line_too_loose()


func exit() -> void:
	state_machine.game.disable_reeling()
	state_machine.game.ui.stop_pull_up_event()
	state_machine.game.ui.start_reeling.disconnect(_start_reeling)
	state_machine.game.ui.stop_reeling.disconnect(_stop_reeling)
	cooldown_timer.timeout.disconnect(_on_cooldown_timeout)
	cooldown_timer.queue_free()
	state_machine.game.ui.pull_up_event_completed.disconnect(_pull_up_completed)
	state_machine.game.ui.pull_up_event_failed.disconnect(_pull_up_failed)
	process_mode = ProcessMode.PROCESS_MODE_DISABLED


func _pick_game_parameters(difficulty: float) -> void:
	var time := inverse_lerp(
		state_machine.game.MIN_DIFFICULTY,
		state_machine.game.MAX_DIFFICULTY,
		difficulty
	)
	
	# Higher = Harder
	tension_increase_rate = lerpf(
		TENSION_MIN_INCREASE_RATE,
		TENSION_MAX_INCREASE_RATE,
		time
	)
	tension_decrease_rate = lerpf(
		TENSION_MIN_DECREASE_RATE,
		TENSION_MAX_DECREASE_RATE,
		time
	)
	
	# Lower = Harder
	pull_up_lower_bound = lerpf(
		MAX_PULL_UP_LOWER_BOUND,
		MIN_PULL_UP_LOWER_BOUND,
		time
	)
	pull_up_upper_bound = lerpf(
		MAX_PULL_UP_UPPER_BOUND,
		MIN_PULL_UP_UPPER_BOUND,
		time
	)
	
	pull_up_cooldown_lower_bound = lerpf(
		MAX_PULL_UP_COOLDOWN_LOWER_BOUND,
		MIN_PULL_UP_COOLDOWN_LOWER_BOUND,
		time
	)
	pull_up_cooldown_upper_bound = lerpf(
		MAX_PULL_UP_COOLDOWN_UPPER_BOUND,
		MIN_PULL_UP_COOLDOWN_UPPER_BOUND,
		time
	)


func _make_timer() -> void:
	cooldown_timer = Timer.new()
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)
	cooldown_timer.timeout.connect(_on_cooldown_timeout)


func _start_cooldown_timer() -> void:
	var time := randf_range(pull_up_cooldown_lower_bound, pull_up_cooldown_upper_bound)
	cooldown_timer.wait_time = time
	cooldown_timer.start()


func _on_line_too_tight() -> void:
	state_machine.change_state_to(Game.States.CASTING)
	state_machine.game.ui.notify_fish_escaped(true)


func _on_line_too_loose() -> void:
	state_machine.change_state_to(Game.States.CASTING)
	state_machine.game.ui.notify_fish_escaped(false)


func _on_fish_caught() -> void:
	state_machine.change_state_to(Game.States.SHOWING_REWARD)


func _start_reeling() -> void:
	reeling = true


func _stop_reeling() -> void:
	reeling = false


func _on_cooldown_timeout() -> void:
	var time := randf_range(pull_up_lower_bound, pull_up_upper_bound)
	state_machine.game.ui.start_pull_up_event(time)


func _pull_up_completed() -> void:
	_start_cooldown_timer()


func _pull_up_failed() -> void:
	state_machine.change_state_to(Game.States.CASTING)
