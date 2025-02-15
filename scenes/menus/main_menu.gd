extends MarginContainer

@export_file var main_scene: String


func _on_play_pressed() -> void:
	WebInput.request_access()
	get_tree().change_scene_to_file(main_scene)
