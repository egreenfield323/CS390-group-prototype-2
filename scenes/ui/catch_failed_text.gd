extends Label

const SNAPPED_TEXT = "Your line snapped!\nReel less next time!"
const FISH_ESCAPED = "The fish escaped!\nReel more next time!"


func notify_catch_failed(line_snapped: bool) -> void:
	text = SNAPPED_TEXT if line_snapped else FISH_ESCAPED
	$Animation.play("appear")
