extends Node2D

signal fish_bite

const MIN_DISTANCE_FROM_TARGET = 150.0
const MIN_SPAWN_COOLDOWN = 1.0
const MAX_SPAWN_COOLDOWN = 3.0

@export var shadow_scene: PackedScene
@export var target: Node2D

var _spawnable_rect: Rect2


func _ready() -> void:
	_create_spawnable_rect()


func start_spawning_fish() -> void:
	_start_spawn_timer()


func clear_fish() -> void:
	$SpawnTimer.stop()
	for shadow in $Fish.get_children():
		shadow.bite_hook.disconnect(_on_fish_bite)
		# Maybe add a fade out then queue_free function to the shadows later.
		shadow.queue_free()


func _start_spawn_timer() -> void:
	$SpawnTimer.wait_time = randf_range(MIN_SPAWN_COOLDOWN, MAX_SPAWN_COOLDOWN)
	$SpawnTimer.start()


func _spawn_fish() -> void:
	var spawn_position := Vector2.ZERO
	
	while (spawn_position == Vector2.ZERO):
		var possible_position := Vector2(
			randf_range(
				_spawnable_rect.position.x,
				_spawnable_rect.position.x + _spawnable_rect.size.x
			),
			randf_range(
				_spawnable_rect.position.y,
				_spawnable_rect.position.y + _spawnable_rect.size.y
			)
		)
		
		if possible_position.distance_to(Vector2.ZERO) >= MIN_DISTANCE_FROM_TARGET:
			spawn_position = possible_position
	
	var fish_shadow: Node2D = shadow_scene.instantiate()
	fish_shadow.position = spawn_position
	fish_shadow.hook = target
	fish_shadow.bite_hook.connect(_on_fish_bite)
	$Fish.add_child(fish_shadow)
	
	_start_spawn_timer()


func _on_fish_bite() -> void:
	fish_bite.emit()
	clear_fish()


# This code will break as soon as the navigation polygon is not a perfect rectangle.
func _create_spawnable_rect() -> void:
	var outline: PackedVector2Array = $Navigation.navigation_polygon.get_outline(0)
	var top_left := outline[0]
	var bottom_right := outline[0]
	
	for point in outline:
		if point.x < top_left.x:
			top_left.x = point.x
		if point.x > bottom_right.x:
			bottom_right.x = point.x
		if point.y < top_left.y:
			top_left.y = point.y
		if point.y > bottom_right.y:
			bottom_right.y = point.y
	
	_spawnable_rect = Rect2(top_left, bottom_right - top_left)
