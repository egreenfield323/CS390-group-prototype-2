extends Sprite2D

signal cast_finished

const MIN_PIXELS_ON_CAST = 25
const MAX_PIXELS_ON_CAST = 515

const CAST_ANIM_TIME = 1.0

@onready var initial_position = position


func _ready() -> void:
	hide()


func cast(distance: float) -> void:
	var pixels := _distance_to_pixels(distance)
	
	show()
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", initial_position + Vector2.DOWN * pixels, CAST_ANIM_TIME)
	tween.finished.connect(
		func():
			cast_finished.emit()
	)


func clear() -> void:
	hide()
	position = initial_position


func trigger_idle_anim() -> void:
	$Animation.play("idle")


func trigger_biting_anim() -> void:
	$Animation.play("fish_biting")


# Call inside _process
func reel_to(distance: float) -> void:
	var pixels := _distance_to_pixels(distance)
	position.y = pixels + initial_position.y


func _distance_to_pixels(distance: float) -> float:
	return remap(
		distance,
		Game.MIN_DISTANCE,
		Game.MAX_DISTANCE,
		MIN_PIXELS_ON_CAST,
		MAX_PIXELS_ON_CAST
	)
