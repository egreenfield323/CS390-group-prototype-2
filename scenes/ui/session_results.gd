extends ColorRect

const MAIN_MENU = "res://scenes/menus/main_menu.tscn"

const COUNT_TEXT = "Number of fish caught: %d"
const WEIGHT_TEXT = "Total weight of fish caught: %.2f lb"
const VALUE_TEXT = "Worth a total of %d gold."
const HIGH_SCORE_TEXT = "(Your high score is %d gold.)"
const NEW_HIGH_SCORE_TEXT = "(New high score!)"


func show_results(count: int, weight: float, value: int) -> void:
	var is_high_score := Scores.submit_score(value)
	
	$Margin/VBox/FishCount.text = COUNT_TEXT % count
	$Margin/VBox/FishWeight.text = WEIGHT_TEXT % weight
	$Margin/VBox/FishValue.text = VALUE_TEXT % value
	
	if is_high_score:
		$Margin/VBox/HighScore.text = NEW_HIGH_SCORE_TEXT
	else:
		$Margin/VBox/HighScore.text = HIGH_SCORE_TEXT % Scores.get_high_score()
	
	show()
	$Appear.play()


func _on_play_again_pressed() -> void:
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU)
