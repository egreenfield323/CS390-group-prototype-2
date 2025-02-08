extends Node2D

@export var cast_distance := 0

var fish_dict = {
	"fish_name": "",
	"species": "",
	"worth": 0,
	"rarity": 0,
	"spawn_chance": 0.0,
	"distance": 0.0,
	"weight": 0.0,
	"difficulty": 0,
	"caught": false,
}

# Order of Fish Rarity - Tetra, Shrimp, Ghost, Basic Fish, Gold Fish
# Blue Tet, Red Tet, Orang Shrimp, Purp Shrimp, Ghost, Blue Basic, Yellow Basic, Brown Basic, Red Basic, Gold
var fish_distribution = [
		[0.30, 0.30, 0.15, 0.15, 0.10, 0.00, 0.00, 0.00, 0.00, 0.00], # Distance 0-2
		[0.10, 0.10, 0.25, 0.25, 0.10, 0.05, 0.05, 0.05, 0.05, 0.00], # Distance 3-5
		[0.05, 0.05, 0.10, 0.10, 0.20, 0.20, 0.10, 0.07, 0.07, 0.06],  # Distance 6-8
		[0.05, 0.05, 0.05, 0.05, 0.10, 0.15, 0.15, 0.15, 0.15, 0.10]   # Distance 9-10
	]
	
# Called when the node enters the scene tree for the first time.
func _ready():
	_change_fish_sprite(cast_distance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Gets the probability of a fish appearing based of distance of the cast
func _get_probability_set(distance: int) -> Array:
	if distance <= 2:
		return fish_distribution[0]
	elif distance <= 5:
		return fish_distribution[1]
	elif distance <= 8:
		return fish_distribution[2]
	else:
		return fish_distribution[3]


# Gives the index of the random number
func _weighted_random_choice(propability_distribution: Array) -> int:
	var rand_value = randf()
	var cumulative = 0.0
   
	for i in range(propability_distribution.size()):
		cumulative += propability_distribution[i]
		if rand_value <= cumulative:
			return i  # Returns the index of the selected fish
	return propability_distribution.size() - 1  # Fallback (shouldn't happen)
	


# Changes the sprites based off the index of the random number
func _change_fish_sprite(cast_distance: int) -> void:
	var probability_distribution = _get_probability_set(cast_distance)
	var fish_sprite_index = _weighted_random_choice(probability_distribution)
	if fish_sprite_index == 0:
		$BlueTetra.visible = true;
	elif fish_sprite_index == 1:
		$RedTetra.visible = true;
	elif fish_sprite_index == 2:
		$OrangeShrimp.visible = true;
	elif fish_sprite_index == 3:
		$PurpleShrimp.visible = true;
	elif fish_sprite_index == 4:
		$GhostFish.visible = true;
	elif fish_sprite_index == 5:
		$BlueFish.visible = true;
	elif fish_sprite_index == 6:
		$YellowFish.visible = true;
	elif fish_sprite_index == 7:
		$BrownFish.visible = true;
	elif fish_sprite_index == 8:
		$RedFish.visible = true;
	else: # sprite_index == 9
		$GoldFish.visible = true;
