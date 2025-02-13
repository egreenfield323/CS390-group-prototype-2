extends RefCounted
class_name Fish

# This class is intended to serve as a data structure for an individual fish. Population variables
# for different fish types should not go here.

enum FishType {
	BLUEGILL,
	SUNFISH,
}

var type: FishType
var weight: float
var difficulty: float


func _init(
	type: FishType,
	weight: float,
	difficulty: float,
) -> void:
	self.type = type
	self.weight = weight
	self.difficulty = difficulty
