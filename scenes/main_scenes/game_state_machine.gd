extends StateMachine

const INITIAL_STATE = Game.States.CASTING

var game: Game


@warning_ignore("shadowed_variable")
func begin(game: Game) -> void:
	self.game = game
	change_state_to(INITIAL_STATE)
