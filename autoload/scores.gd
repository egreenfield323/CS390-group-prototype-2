extends Node

var high_score := 0 : get = get_high_score


func get_high_score() -> int:
	return high_score


# Returns true if value is a new high score.
func submit_score(value: int) -> bool:
	if value > high_score:
		high_score = value
		return true
	
	return false
