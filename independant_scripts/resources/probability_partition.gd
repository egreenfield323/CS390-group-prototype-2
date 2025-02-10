@tool
extends Resource
class_name ProbabilityPartition

const NORMALIZED_SUM = 1.0

@export_range(0.0, NORMALIZED_SUM) var probabilities: Array[float] = [] : set = _set_probabilities


func _set_probabilities(new_probabilities: Array[float]) -> void:
	# In case a new array with the same contents is somehow assigned:
	if probabilities == new_probabilities:
		probabilities = new_probabilities
		return
	
	# In case the range limitation is somehow bypassed:
	for index in range(new_probabilities.size()):
		new_probabilities[index] = clampf(new_probabilities[index], 0.0, NORMALIZED_SUM)
	
	# New element appended to end of the array. Should initialize to zero, which is only an issue
	# if the sum of the probabilities is 0.
	if new_probabilities.size() > probabilities.size():
		if _sum(new_probabilities) == 0.0:
			new_probabilities[new_probabilities.size() - 1] = NORMALIZED_SUM
		probabilities = new_probabilities
		return
	
	# An element was deleted somewhere in the array. We want to merge its value with the value of 
	# the probability now at its index. (Above it in a stacked line chart.) If it is the last
	# value, we will add it to the previous value instead. Additionally, if it was the only value,
	# we will simply add it back.
	if new_probabilities.size() < probabilities.size():
		if new_probabilities.size() == 0:
			new_probabilities.append(NORMALIZED_SUM)
			probabilities = new_probabilities
			return
		
		var index_added_to := _find_differing_index(probabilities, new_probabilities)
		
		if index_added_to == -1:
			index_added_to = 0
		
		new_probabilities[index_added_to] += probabilities[index_added_to - 1]
		probabilities = new_probabilities
		return
	
	# Value modified
	
	# Handle an edge case that would break the code afterwards.
	if new_probabilities.size() == 1:
		new_probabilities[0] = NORMALIZED_SUM
		probabilities = new_probabilities
		return
	
	var modified_index := _find_differing_index(probabilities, new_probabilities)
	var difference := NORMALIZED_SUM - _sum(new_probabilities)
	
	for index in _get_modify_order(new_probabilities.size(), modified_index):
		var old_value := new_probabilities[index]
		# It is not possible for old_value + difference to be greater than 1.0.
		var new_value := maxf(old_value + difference, 0.0)
		new_probabilities[index] = new_value
		difference -= new_value - old_value
		
		if difference == 0.0:
			probabilities = new_probabilities
			return
	
	# Don't warn if just floating point error.
	if not is_equal_approx(_sum(new_probabilities), NORMALIZED_SUM):
		push_warning("Unable to normalize partitions: %s set to %s" % [
			str(probabilities), str(new_probabilities)
		])
	new_probabilities = probabilities


func _sum(values: Array[float]) -> float:
	var sum := 0.0
	for value in values:
		sum += value
	
	return sum


func _find_differing_index(a: Array, b: Array) -> int:
	var longer: Array = []
	var shorter: Array = []
	
	if a.size() > b.size():
		longer = a
		shorter = b
	else:
		longer = b
		shorter = a
	
	var differing_index := shorter.size()
	
	for index in range(shorter.size()):
		var shorter_element = shorter[index]
		var longer_element = longer[index]
		
		if shorter_element != longer_element:
			differing_index = index
			break
	
	return differing_index


# Start by pushing up, then go down. If at the top, start pushing down immediately. Never modify the
# value at the manually edited index (index_modified).
func _get_modify_order(array_size: int, index_modified: int) -> Array[int]:
	if array_size <= 1:
		return []
	
	var order: Array[int] = []
	var push_up := true
	var previous: int = index_modified
	
	while (previous != 0 or push_up):
		if push_up:
			var next := previous + 1
			if next >= array_size:
				push_up = false
				previous = index_modified
				continue
			
			order.append(next)
			previous = next
			continue
		
		var next := previous - 1
		order.append(next)
		previous = next
	
	return order
