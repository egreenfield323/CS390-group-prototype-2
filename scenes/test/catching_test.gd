extends Node

@export var catch_probabilities: CatchDistributions


func _ready() -> void:
	print(catch_probabilities.sample_probabilities_at(50))
	print(catch_probabilities.sample_probabilities_at(90))
	
	# These two should cause extrapolation warnings.
	print(catch_probabilities.sample_probabilities_at(10))
	print(catch_probabilities.sample_probabilities_at(110))
	
	print("Distance: 50")
	for i in range(10):
		print(catch_probabilities.get_caught_fish_type(50))
	
	print("Distance: 90")
	for i in range(10):
		print(catch_probabilities.get_caught_fish_type(90))
