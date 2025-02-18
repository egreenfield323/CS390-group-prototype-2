extends CharacterBody2D

signal bite_hook

const FADE_DURATION = 0.5

@export var hook: Node2D
@export var speed := 200
@export var accel := 5
@export var decel := 5

@onready var nav := $NavigationAgent2D

var target_position
var moving := false


func _ready() -> void:
	modulate = Color(1.0, 1.0, 1.0, 0.0)
	if hook:
		look_at(hook.global_position)
		var tween := create_tween()
		tween.tween_property(self, "modulate", Color.WHITE, FADE_DURATION)


func _physics_process(delta: float) -> void: 
	if hook:
		target_position = hook.global_position
	else:
		target_position = global_position
		
	if global_position == target_position: stop_moving()

	nav.set_target_position(target_position)
	var direction = (nav.get_next_path_position() - global_position).normalized()
	
	if moving:
		velocity = velocity.lerp(direction * speed, accel * delta)
	else:
		velocity = velocity.lerp(Vector2.ZERO, decel * delta)
	
	move_and_slide()


func stop_moving() -> void:
	moving = false


func start_moving() -> void:
	moving = true
	$Animation.play("move")
	$Move.play()


func disappear() -> void:
	stop_moving()
	target_position = Vector2.ZERO
	var tween := create_tween()
	tween.finished.connect(
		func():
			queue_free()
	)
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), FADE_DURATION)

# I've also connected NavigationAgent's target_reached so we don't have to give the bobber a
# collision.
func _on_hook_reached() -> void:
	bite_hook.emit()
	stop_moving()
	target_position = Vector2.ZERO


func _on_area_2d_body_entered(_body: Node2D) -> void:
	_on_hook_reached()


func _on_move_timer_timeout() -> void:
	start_moving()
	$StopTimer.start(randf_range(0.2, 0.5))


func _on_stop_timer_timeout() -> void:
	stop_moving()
	$MoveTimer.start(randf_range(0.5, 2.0))
