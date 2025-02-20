extends Node2D
class_name Game

enum States {
	CASTING,
	AWAITING_BITE,
	BITING,
	FISH_HOOKED,
	SHOWING_REWARD,
}

const MIN_ACELLERATION = 0.0
const MAX_ACELLERATION = 120.0

const MIN_DISTANCE = 20.0
const MAX_DISTANCE = 100.0

const MIN_LINE_TENSION = 0.0
const MAX_LINE_TENSION = 100.0

const MAX_DIFFICULTY = 10.0
const MIN_DIFFICULTY = 0.0

const MIN_PULLS = 1
const MAX_PULLS = 20

const SESSION_SECONDS = 300

@onready var state_map = {
	States.CASTING: $States/Casting,
	States.AWAITING_BITE: $States/AwaitingBite,
	States.BITING: $States/Biting,
	States.FISH_HOOKED: $States/FishHooked,
	States.SHOWING_REWARD: $States/ShowingReward,
}

@onready var ui: CanvasLayer = $UI
@onready var player_anim: AnimationPlayer = $Player/Animation
@onready var sounds: SoundBank = $SoundBank

var session_seconds_remaining = SESSION_SECONDS : set = _set_session_seconds

var gold := 0
var total_weight := 0.0
var fish_count := 0

var current_cast_distance := 0.0
var bobber_distance := 0.0 : set = _set_bobber_distance
var line_tension := 50.0 : set = _set_line_tension
var hooked_fish: Fish


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$States.states = state_map
	$States.begin(self)
	ui.set_session_seconds(SESSION_SECONDS)
	WebInput.request_access()


static func acceleration_to_distance(acceleration: float) -> float:
	return clampf(
		remap(acceleration, MIN_ACELLERATION, MAX_ACELLERATION, MIN_DISTANCE, MAX_DISTANCE),
		MIN_DISTANCE, MAX_DISTANCE
	)


func be_ready_for_casting() -> void:
	$Bobber.clear()
	ui.enable_casting()


func trigger_cast(distance: float, call_on_finished: Callable) -> void:
	$Bobber.cast(distance)
	# Again, disconnecting after recieving the signal would be ideal.
	if not $Bobber.cast_finished.is_connected(call_on_finished):
		$Bobber.cast_finished.connect(call_on_finished)
	current_cast_distance = distance


func trigger_fish_swarm(call_when_done: Callable) -> void:
	# Ideally this would disconnect when this signal is recieved, but I can't get
	# that to work out.
	if not $FishShadows.fish_bite.is_connected(call_when_done):
		$FishShadows.fish_bite.connect(call_when_done)
	$FishShadows.start_spawning_fish()
	$Bobber.trigger_idle_anim()
	bobber_distance = current_cast_distance


func trigger_bite() -> void:
	$Bobber.trigger_biting_anim()


func select_fish() -> void:
	hooked_fish = FishSelection.choose_fish(current_cast_distance)


func enable_reeling() -> void:
	ui.enable_reeling()
	ui.show_line_tension()
	line_tension = (MIN_LINE_TENSION + MAX_LINE_TENSION) / 2.0


func disable_reeling() -> void:
	ui.disable_reeling()
	ui.hide_line_tension()


func aquire_fish() -> void:
	fish_count += 1
	total_weight += hooked_fish.weight
	gold += hooked_fish.value
	ui.show_fish_caught(hooked_fish)


func _session_over() -> void:
	ui.show_results(fish_count, total_weight, gold)
	process_mode = ProcessMode.PROCESS_MODE_DISABLED


func _on_session_timer_timeout() -> void:
	session_seconds_remaining -= 1
	if session_seconds_remaining <= 0:
		_session_over()


func _set_line_tension(new_line_tension: float) -> void:
	line_tension = clampf(new_line_tension, MIN_LINE_TENSION, MAX_LINE_TENSION)
	ui.set_line_tension(new_line_tension)


func _set_bobber_distance(new_bobber_distance: float) -> void:
	bobber_distance = clampf(new_bobber_distance, 0.0, MAX_DISTANCE)
	$Bobber.reel_to(new_bobber_distance)


func _set_session_seconds(new_session_seconds: int) -> void:
	session_seconds_remaining = new_session_seconds
	ui.set_session_seconds(session_seconds_remaining)


func _on_bobber_cast_finished() -> void:
	sounds.play("bobber_land")
