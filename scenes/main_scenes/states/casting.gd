extends State

var game: Game


func enter() -> void:
	game = state_machine.game
	game.ui.cast_released.connect(_on_cast_released)
	game.be_ready_for_casting()


func _on_cast_released(acelleration: float) -> void:
	game.trigger_cast(
		Game.acceleration_to_distance(acelleration),
		_on_cast_finished
	)


func _on_cast_finished() -> void:
	state_machine.change_state_to(Game.States.AWAITING_BITE)


func exit() -> void:
	game.ui.cast_released.disconnect(_on_cast_released)
