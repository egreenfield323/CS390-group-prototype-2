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
	$Margin/TopBox/LineTension.hide()
	$FishCaught.hide()
	$Margin/PullUpBox.hide()
	$Margin/PullUpBox.pull_up_event_complete.connect(
		func():
			pull_up_event_completed.emit()
			_clear_phone_graphic()
	)
	$Margin/PullUpBox.pull_up_event_failed.connect(
		func():
			pull_up_event_failed.emit()
			_clear_phone_graphic()
	)
	$SessionResults.hide()
	$Margin/TopBox/Gold.hide()


func enable_casting() -> void:
	$Margin/CastButton.show()


func enable_reeling() -> void:
	$Margin/ReelButton.show()


func disable_reeling() -> void:
	$Margin/ReelButton.hide()


func show_line_tension() -> void:
	$Margin/TopBox/LineTension.show()


func hide_line_tension() -> void:
	$Margin/TopBox/LineTension.hide()


func set_line_tension(new_line_tension: float) -> void:
	$Margin/TopBox/LineTension.value = new_line_tension


func notify_fish_escaped(line_snapped: bool) -> void:
	$Margin/CatchFailed.notify_catch_failed(line_snapped)


func start_pull_up_event(time: float) -> void:
	$Margin/PullUpBox.start_pull_up_event(time)
	$Margin/PhoneGraphic/Animation.play("pull_up")


func stop_pull_up_event() -> void:
	$Margin/PullUpBox.stop_pull_up_event()
	_clear_phone_graphic()


# Will pass a Fish eventually.
func show_fish_caught(fish: Fish) -> void:
	$FishCaught/Margin/VBox/FishStats.display_fish(fish)
	$FishCaught.show()
	$Margin.hide()


func show_gold(gold: int) -> void:
	$Margin/TopBox/Gold.text = "Gold: " + str(gold)
	$Margin/TopBox/Gold/Animation.play("show_gold")


func show_results(count: int, weight: float, value: int) -> void:
	$SessionResults.show_results(count, weight, value)
	$Margin.hide()


func set_session_seconds(seconds: int) -> void:
	$Margin/TopBox/SessionTimer.seconds = seconds


func _clear_phone_graphic() -> void:
	$Margin/PhoneGraphic/Animation.stop()
	$Margin/PhoneGraphic.hide()


func _on_cast_button_down() -> void:
	WebInput.start_cast()
	$Margin/CastText/Animation.play("show")
	$Margin/PhoneGraphic/Animation.play("cast")


func _on_cast_button_released() -> void:
	$Margin/CastButton.hide()
	cast_released.emit(WebInput.stop_cast())
	$Margin/CastText/Animation.play("hide")
	_clear_phone_graphic()


func _on_reel_button_button_down() -> void:
	start_reeling.emit()


func _on_reel_button_button_up() -> void:
	stop_reeling.emit()


func _on_continue_pressed() -> void:
	$FishCaught.hide()
	$Margin.show()
	continue_game.emit()
