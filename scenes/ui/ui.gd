extends CanvasLayer

signal cast_released(acceleration: float)


func _ready() -> void:
	$Margin/CastButton.hide()


func enable_casting() -> void:
	$Margin/CastButton.show()


func _on_cast_button_down() -> void:
	WebInput.start_cast()


func _on_cast_button_released() -> void:
	$Margin/CastButton.hide()
	cast_released.emit(WebInput.stop_cast())
