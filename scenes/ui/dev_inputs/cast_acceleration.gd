extends HBoxContainer


func _on_slider_value_changed(value: float) -> void:
	$Value.text = str(value)
