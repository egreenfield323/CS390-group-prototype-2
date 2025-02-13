extends CharacterBody2D

@onready var nav := $NavigationAgent2D

@export var HOOK : Node
@export var SPEED := 200
@export var ACCEL := 5

var target_position

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	if HOOK != null:
		target_position = HOOK.global_position
	else:
		target_position = self.global_position
	
	if global_position == target_position:
		stop_moving()
	
	nav.set_target_position(target_position)
	var direction = (nav.get_next_path_position() - global_position).normalized()
	
	velocity = velocity.lerp(direction * SPEED, ACCEL * delta)
	move_and_slide()

func stop_moving():
	SPEED = 0
	ACCEL = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	#TODO: Start fish catching
	target_position = Vector2(0,0)
	body.queue_free()
