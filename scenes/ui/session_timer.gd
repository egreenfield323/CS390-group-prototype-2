extends Label

const TEXT = "Session time remaining: %d:%02d"

var seconds := 0 : set = _set_seconds


func _set_seconds(new_seconds: int) -> void:
	seconds = new_seconds
	
	@warning_ignore("integer_division")
	var minutes := seconds / 60
	var remaining := seconds % 60
	
	text = TEXT % [minutes, remaining]
