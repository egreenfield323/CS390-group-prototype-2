extends Resource
class_name Distribution

# Abstract, override this in subclasses.
func get_spawn_weight(cast_distance: float) -> float:
	return 0.0
