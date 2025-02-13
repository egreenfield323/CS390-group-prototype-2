extends Sprite2D

signal cast_finished

const MIN_PIXELS_ON_CAST = 75
const MAX_PIXELS_ON_CAST = 650

const CAST_ANIM_TIME = 1.0


func _ready() -> void:
	hide()


func cast(distance: float) -> void:
	var pixels := _distance_to_pixels(distance)
	
	show()
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", Vector2.DOWN * pixels, CAST_ANIM_TIME)
	tween.finished.connect(
		func():
			cast_finished.emit()
	)


func clear() -> void:
	hide()
	position = Vector2.ZERO


func trigger_fish_swarm_anim(call_when_done: Callable) -> void:
	$Animation.animation_finished.connect(
		func(_anim_name: String): call_when_done.call()
	)
	$Animation.play("fish_swarm")


func trigger_biting_anim() -> void:
	$Animation.play("fish_biting")


# Call inside _process
func reel_to(distance: float) -> void:
	var pixels := _distance_to_pixels(distance)
	position.y = pixels


func _distance_to_pixels(distance: float) -> float:
	return remap(
		distance,
		Game.MIN_DISTANCE,
		Game.MAX_DISTANCE,
		MIN_PIXELS_ON_CAST,
		MAX_PIXELS_ON_CAST
	)
