extends CharacterBody2D

@onready var nav := $NavigationAgent2D

@export var HOOK: Node
@export var SPEED := 200
@export var ACCEL := 5
@export var DECEL := 5

var target_position
var moving := false

func _physics_process(delta: float) -> void: 
	if HOOK and HOOK != null:
		target_position = HOOK.global_position
	else:
		target_position = global_position
		
	if global_position == target_position: stop_moving()

	nav.set_target_position(target_position)
	var direction = (nav.get_next_path_position() - global_position).normalized()
	
	if moving:
		velocity = velocity.lerp(direction * SPEED, ACCEL * delta)
	else:
		velocity = velocity.lerp(Vector2.ZERO, DECEL * delta)
	
	move_and_slide()

func stop_moving() -> void: moving = false
func start_moving() -> void: moving = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	stop_moving()
	target_position = Vector2.ZERO
	body.queue_free()

func _on_move_timer_timeout() -> void:
	start_moving()
	$StopTimer.start(randf_range(0.2, 0.5))

func _on_stop_timer_timeout() -> void:
	stop_moving()
	$MoveTimer.start(randf_range(0.5, 2.0))
