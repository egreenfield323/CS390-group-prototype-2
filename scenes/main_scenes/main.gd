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

const MIN_DISTANCE = 0.0
const MAX_DISTANCE = 100.0

const MAX_DIFFICULTY = 10.0
const MIN_DIFFICULTY = 0.0

const MIN_PULLS = 1
const MAX_PULLS = 20

@onready var state_map = {
	States.CASTING: $States/Casting,
	States.AWAITING_BITE: $States/AwaitingBite,
	States.BITING: $States/Biting,
	States.FISH_HOOKED: $States/FishHooked,
	States.SHOWING_REWARD: $States/ShowingReward,
}

@onready var ui := $UI

var current_cast_distance := 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$States.states = state_map
	$States.begin(self)


static func acceleration_to_distance(acceleration: float) -> float:
	return remap(acceleration, MIN_ACELLERATION, MAX_ACELLERATION, MIN_DISTANCE, MAX_DISTANCE)


func be_ready_for_casting() -> void:
	ui.enable_casting()


func trigger_cast(distance: float, call_on_finished: Callable) -> void:
	$Bobber.cast(distance)
	$Bobber.cast_finished.connect(call_on_finished)


func trigger_fish_swarm(call_when_done: Callable) -> void:
	# Ideally we would disconnect this once the signal is recieved once.
	$FishShadows.fish_bite.connect(call_when_done)
	$FishShadows.start_spawning_fish()
	$Bobber.trigger_idle_anim()


func trigger_bite() -> void:
	$Bobber.trigger_biting_anim()


func catch_event(fish_difficulty: float) -> void:
	var time := inverse_lerp(MAX_DIFFICULTY, MIN_DIFFICULTY, fish_difficulty)
	var pulls := int(lerp(MIN_PULLS, MAX_PULLS, time))
	
	for pull in range(pulls):
		
		
		pass
