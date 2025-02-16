extends Node

const DATA_FILE = "res://data/fishtypes.json"

var data: Dictionary = {} : get = _get_data


func choose_fish(distance: float) -> Fish:
	var probability_set := _get_probability_set(distance)
	var type := _weighted_random_choice(probability_set)
	return _get_fish_by_type(type)


func _get_probability_set(distance: float) -> Array[float]:
	for point in data["distribution"]:
		var max_distance: float = point["max_distance"]
		if distance > max_distance:
			continue
		
		var probabilities: Array[float]
		probabilities.assign(point["probabilities"])
		return probabilities
	
	var set_max_distance: float = data["distribution"].back()["max_distance"]
	push_warning("Distance provided (%f) was greater than the max distance of the data, %f." % [
		distance, set_max_distance
	])
	return data["distribution"].back()["probabilities"]


func _weighted_random_choice(propability_distribution: Array[float]) -> Fish.FishType:
	var rand_value = randf()
	var cumulative = 0.0
   
	for i in range(propability_distribution.size()):
		cumulative += propability_distribution[i]
		if rand_value <= cumulative:
			# Returns the index of the selected fish translated into the FishType enum.
			return i as Fish.FishType
	
	push_warning("Probabilities %s did not sum to 1.0, using last fish type.")
	# Fallback (shouldn't happen)
	return (propability_distribution.size() - 1) as Fish.FishType


func _get_fish_by_type(type: Fish.FishType) -> Fish:
	var fish_params: Dictionary = data["fish"][type as int]
	var weight := randf_range(
		fish_params["weight_range"][0],
		fish_params["weight_range"][1]
	)
	var difficulty := randf_range(
		fish_params["difficulty"][0],
		fish_params["difficulty"][1]
	)
	var value: int = fish_params["value"]
	var texture: AtlasTexture = AtlasTexture.new()
	texture.atlas = load(fish_params["sprite"])
	texture.region = Rect2(
		fish_params["sprite_region"][0],
		fish_params["sprite_region"][1],
		fish_params["sprite_region"][2],
		fish_params["sprite_region"][3]
	)
	var display_name: String = fish_params["type"]
	
	return Fish.new(
		type,
		weight,
		difficulty,
		value,
		texture,
		display_name
	)


# Lazy loading the data file the first time it is needed.
func _get_data() -> Dictionary:
	if not data.is_empty():
		return data
	
	var json_as_text = FileAccess.get_file_as_string(DATA_FILE)
	var json_as_dict = JSON.parse_string(json_as_text)
	
	data = json_as_dict
	return data
