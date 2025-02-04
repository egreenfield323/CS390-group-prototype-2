extends Sprite2D

const ROTATION_TIME = 1.0


func _process(delta: float) -> void:
	rotate(delta * TAU * ROTATION_TIME)
