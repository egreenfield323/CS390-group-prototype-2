extends State

var game: Game


func enter() -> void:
	game = state_machine.game
	game.ui.cast_released.connect(_on_cast_released)
	game.be_ready_for_casting()
	game.player_anim.play("idle")


func _on_cast_released(acelleration: float) -> void:
	game.trigger_cast(
		Game.acceleration_to_distance(acelleration),
		_on_cast_finished
	)
	game.player_anim.animation_finished.connect(_on_player_cast_anim_finished)
	game.player_anim.play("cast")


func _on_cast_finished() -> void:
	state_machine.change_state_to(Game.States.AWAITING_BITE)


func _on_player_cast_anim_finished(anim_name: String) -> void:
	game.player_anim.animation_finished.disconnect(_on_player_cast_anim_finished)
	if anim_name == "cast":
		game.player_anim.play("idle_casted")


func exit() -> void:
	game.ui.cast_released.disconnect(_on_cast_released)
