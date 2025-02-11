@tool
extends Resource
class_name CatchDistributions

# Make this an Array[FishEnum] when that exists.
# Yes it would be better to use a dictionary, but we cannot type dictionaries
# yet, so aligning two typed arrays will have to do.
@export var fish_types: Array[int] = [0] : set = _set_fish_types
@export var partitions: Array[ProbabilityPartition] = [] : set = _set_partitions
@export var partition_distances: Array[float] = [] : set = _set_partition_distances

var _minimum_distance: float = 0.0
var _maximum_distance: float = 0.0

var _partition_distances_size_mutable := false

# Make this return FishEnum when it exists.
func get_caught_fish_type(distance: float) -> int:
	var probabilities := sample_probabilities_at(distance)
	
	var keys: Array = []
	var upper_bounds: Array[float] = []
	var previous_bound := 0.0
	for key in probabilities.keys():
		keys.append(key)
		previous_bound += probabilities[key]
		upper_bounds.append(previous_bound)
	
	var value := randf()
	for index in range(keys.size()):
		if value < upper_bounds[index]:
			return keys[index]
	
	push_warning("Probabilities added to %f, possible floating point error." % previous_bound)
	return keys.back()


# {fish_type (int): probability (float [0, 1])}
func sample_probabilities_at(distance: float) -> Dictionary:
	if partitions.size() == 0:
		push_error("Cannot sample probabilities, there are none provided!")
		return {}
	
	var nearest_farther_partition: ProbabilityPartition = null
	var nearest_closer_partition: ProbabilityPartition = null
	
	var nearest_farther_distance := _maximum_distance - distance
	var nearest_closer_distance := distance - _minimum_distance
	
	for index in range(partitions.size()):
		var partition_distance := partition_distances[index]
		var distance_to_partition := absf(partition_distance - distance)
		
		if partition_distance >= distance and distance_to_partition <= nearest_farther_distance:
			nearest_farther_distance = distance_to_partition
			nearest_farther_partition = partitions[index]
		
		if partition_distance <= distance and distance_to_partition <= nearest_closer_distance:
			nearest_closer_distance = distance_to_partition
			nearest_closer_partition = partitions[index]
	
	if distance < _minimum_distance:
		push_warning(
			("Extrapolating probability data, checking probabilities for distance %f when minimum " +
			"provided is %f") % [distance, _minimum_distance]
		)
		return _construct_probability_dict(nearest_farther_partition.probabilities, fish_types)
		
	elif distance > _maximum_distance:
		push_warning(
			("Extrapolating probability data, checking probabilities for distance %f when maximum " +
			"provided is %f") % [distance, _maximum_distance]
		)
		return _construct_probability_dict(nearest_closer_partition.probabilities, fish_types)
	
	return _construct_probability_dict(
		_interpolate_probabilities(
			nearest_closer_partition.probabilities,
			nearest_farther_partition.probabilities,
			nearest_closer_distance,
			nearest_farther_distance
		),
		fish_types
	)


func _construct_probability_dict(probabilities: Array[float], types: Array) -> Dictionary:
	if probabilities.size() != types.size():
		push_error("Size of probabilities in the partition do not match the number of types.")
		return {}
	
	var result := {}
	for index in range(probabilities.size()):
		result[types[index]] = probabilities[index]
	
	return result


func _interpolate_probabilities(
	closer: Array[float],
	farther: Array[float],
	distance_to_closer: float,
	distance_to_farther: float
) -> Array[float]:
	var result: Array[float] = []
	
	var time := inverse_lerp(-distance_to_closer, distance_to_farther, 0.0)
	for index in range(closer.size()):
		var probability := lerpf(closer[index], farther[index], time)
		result.append(probability)
	
	return result


func _set_fish_types(new_fish_types: Array[int]) -> void:
	if not Engine.is_editor_hint():
		fish_types = new_fish_types
		return
	
	print("Fish: " + str(fish_types) + " -> " + str(new_fish_types))
	
	if new_fish_types.size() == 0:
		push_warning("Must have at least one fish type.")
		return
		
	fish_types = new_fish_types
	
	var type_count := fish_types.size()
	for partition in partitions:
		partition.enforced_size = type_count


func _set_partitions(new_partitions: Array[ProbabilityPartition]) -> void:
	if not Engine.is_editor_hint():
		partitions = new_partitions
		return
	
	print("Partitions: " + str(partitions) + " -> " + str(new_partitions))
	_partition_distances_size_mutable = true
	if new_partitions.size() > partitions.size():
		new_partitions[new_partitions.size() - 1] = ProbabilityPartition.new()
		new_partitions.back().enforced_size = fish_types.size()
		var new_partition_distances := partition_distances.duplicate()
		new_partition_distances.append(0.0)
		_set_partition_distances(new_partition_distances)
	elif new_partitions.size() < partitions.size():
		var new_partition_distances := partition_distances.duplicate()
		new_partition_distances.remove_at(_find_deleted_index(
			partitions,
			new_partitions
		))
		_set_partition_distances(new_partition_distances)
	_partition_distances_size_mutable = false
	
	partitions = new_partitions


func _set_partition_distances(new_partition_distances: Array[float]) -> void:
	if not Engine.is_editor_hint():
		partition_distances = new_partition_distances
		_pick_min_and_max_distances(partition_distances)
		return
	
	if (
		new_partition_distances.size() != partition_distances.size()
		and not _partition_distances_size_mutable
	):
		push_warning(
			"Cannot directly modify partition distances size, please add or delete partitions " +
			"instead."
		)
		return
	
	partition_distances = new_partition_distances
	
	if partition_distances.size() == 0:
		return
	
	_pick_min_and_max_distances(partition_distances)


func _pick_min_and_max_distances(distances: Array[float]) -> void:
	var minimum: float = distances.front()
	var maximum: float = distances.front()
	for distance in distances:
		if distance < minimum:
			minimum = distance
		elif distance > maximum:
			maximum = distance
	
	_minimum_distance = minimum
	_maximum_distance = maximum


func _find_deleted_index(original: Array, new: Array) -> int:
	if original.size() <= new.size():
		return -1
	
	for index in range(new.size()):
		if original[index] != new[index]:
			return index
	
	return original.size() - 1
