extends Node2D

const MAX_DIFFICULTY = 10.0
const MIN_DIFFICULTY = 0.0

const MIN_PULLS = 1
const MAX_PULLS = 20


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func catch_event(fish_difficulty: float) -> void:
	var time := inverse_lerp(MAX_DIFFICULTY, MIN_DIFFICULTY, fish_difficulty)
	var pulls := int(lerp(MIN_PULLS, MAX_PULLS, time))
	
	for pull in range(pulls):
		
		
		pass
