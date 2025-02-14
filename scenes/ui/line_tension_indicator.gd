extends ProgressBar

@export var value_gradient: Gradient

@onready var inner_stylebox: StyleBoxFlat = get_theme_stylebox("fill")


func _on_value_changed(new_value: float) -> void:
	var time := inverse_lerp(min_value, max_value, new_value)
	inner_stylebox.bg_color = value_gradient.sample(time)
