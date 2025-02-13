extends State


func enter() -> void:
	state_machine.game.trigger_fish_swarm(_on_fish_bite)


func _on_fish_bite() -> void:
	state_machine.change_state_to(Game.States.BITING)
