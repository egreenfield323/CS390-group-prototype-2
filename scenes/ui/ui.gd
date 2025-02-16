extends CanvasLayer

signal cast_released(acceleration: float)
signal start_reeling
signal stop_reeling
signal continue_game
signal pull_up_event_completed
signal pull_up_event_failed


func _ready() -> void:
	$Margin/CastButton.hide()
	$Margin/ReelButton.hide()
	$Margin/VBox/LineTension.hide()
	$FishCaught.hide()
	$Margin/PullUpBox.hide()
	$Margin/PullUpBox.pull_up_event_complete.connect(
		func(): pull_up_event_completed.emit()
	)
	$Margin/PullUpBox.pull_up_event_failed.connect(
		func(): pull_up_event_failed.emit()
	)
	$SessionResults.hide()
	$Margin/VBox/Gold.hide()


func enable_casting() -> void:
	$Margin/CastButton.show()


func enable_reeling() -> void:
	$Margin/ReelButton.show()


func disable_reeling() -> void:
	$Margin/ReelButton.hide()


func show_line_tension() -> void:
	$Margin/VBox/LineTension.show()


func hide_line_tension() -> void:
	$Margin/VBox/LineTension.hide()


func set_line_tension(new_line_tension: float) -> void:
	$Margin/VBox/LineTension.value = new_line_tension


func start_pull_up_event(time: float) -> void:
	$Margin/PullUpBox.start_pull_up_event(time)


func stop_pull_up_event() -> void:
	$Margin/PullUpBox.stop_pull_up_event()


# Will pass a Fish eventually.
func show_fish_caught(fish: Fish) -> void:
	$FishCaught/Margin/VBox/FishStats.display_fish(fish)
	$FishCaught.show()


func show_gold(gold: int) -> void:
	$Margin/VBox/Gold.text = "Gold: " + str(gold)
	$Margin/VBox/Gold/Animation.play("show_gold")


func show_results(count: int, weight: float, value: int) -> void:
	$SessionResults.show_results(count, weight, value)


func set_session_seconds(seconds: int) -> void:
	$Margin/VBox/SessionTimer.seconds = seconds


func _on_cast_button_down() -> void:
	WebInput.start_cast()


func _on_cast_button_released() -> void:
	$Margin/CastButton.hide()
	cast_released.emit(WebInput.stop_cast())


func _on_reel_button_button_down() -> void:
	start_reeling.emit()


func _on_reel_button_button_up() -> void:
	stop_reeling.emit()


func _on_continue_pressed() -> void:
	$FishCaught.hide()
	continue_game.emit()
