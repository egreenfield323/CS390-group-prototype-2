extends State


func enter() -> void:
	state_machine.game.ui.continue_game.connect(_on_continue_game)
	state_machine.game.ui.show_fish_caught()


func exit() -> void:
	state_machine.game.ui.continue_game.disconnect(_on_continue_game)


func _on_continue_game() -> void:
	state_machine.change_state_to(Game.States.CASTING)
