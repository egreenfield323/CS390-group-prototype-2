extends Node2D

@export var cast_distance := 0

var fish_data = {}

var fish_dict = {
	"type": "",
	"value": 0,
	"rarity": "",
	"weight_range": [],
	"difficulty": []
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
	#_change_fish_sprite(cast_distance)
	set_fish_info(randi_range(0,9))


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
	match fish_sprite_index:
		0:
			$BlueTetra.visible = true;
		1:
			$RedTetra.visible = true;
		2:
			$OrangeShrimp.visible = true;
		3:
			$PurpleShrimp.visible = true;
		4:
			$GhostFish.visible = true;
		5:
			$BlueFish.visible = true;
		6:
			$YellowFish.visible = true;
		7:
			$BrownFish.visible = true;
		8:
			$RedFish.visible = true;
		9:
			$GoldFish.visible = true;

func load_fish_data():
	var file = "res://Fishes/fishtypes.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
	
	fish_data = json_as_dict

func set_fish_info(fish_index):
	if fish_data.is_empty():
		load_fish_data()
	
	var fish = fish_data["fish"][fish_index]
	
	var sprite = $Sprite2D
	sprite.texture = load(fish["sprite"])
	
	var sr = fish["sprite_region"]
	sprite.region_enabled = true
	sprite.region_rect = Rect2(sr[0], sr[1], sr[2], sr[3])
	
	for key in fish_dict:
		if key in fish:
			fish_dict[key] = fish[key]
	
	print(fish_dict)
