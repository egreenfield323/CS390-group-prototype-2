extends VBoxContainer

const NAME_FORMAT = "%s"
const WEIGHT_FORMAT = "%.2f lb"
const VALUE_FORMAT = "Worth %d Gold"


func display_fish(fish: Fish) -> void:
	$Margin/Texture.texture = fish.texture
	$Name.text = NAME_FORMAT % fish.display_name
	$Weight.text = WEIGHT_FORMAT % fish.weight
	$Value.text = VALUE_FORMAT % fish.value
