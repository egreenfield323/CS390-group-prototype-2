extends State


func enter() -> void:
	state_machine.game.ui.continue_game.connect(_on_continue_game)
	state_machine.game.aquire_fish()
	state_machine.game.player_anim.play("idle")
	state_machine.game.sounds.play("fish_caught")


func exit() -> void:
	state_machine.game.ui.continue_game.disconnect(_on_continue_game)
	state_machine.game.ui.show_gold(state_machine.game.gold)


func _on_continue_game() -> void:
	state_machine.change_state_to(Game.States.CASTING)
