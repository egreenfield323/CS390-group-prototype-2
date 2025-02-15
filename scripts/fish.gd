extends RefCounted
class_name Fish

# This class is intended to serve as a data structure for an individual fish. Population variables
# for different fish types should not go here.

enum FishType {
	BLUE_TETRA,
	RED_TETRA,
	ORANGE_SHRIMP,
	PURPLE_SHRIMP,
	BLUE_CICHLID,
	YELLOW_CICHLID,
	BROWN_ROCKFISH,
	GHOST_FISH,
	RED_DRUM,
	GOLD_FISH,
}

var type: FishType
var weight: float
var difficulty: float
var value: int
var texture: Texture2D
var display_name: String


@warning_ignore("shadowed_variable")
func _init(
	type: FishType,
	weight: float,
	difficulty: float,
	value: int,
	texture: Texture2D,
	display_name: String
) -> void:
	self.type = type
	self.weight = weight
	self.difficulty = difficulty
	self.value = value
	self.texture = texture
	self.display_name = display_name
