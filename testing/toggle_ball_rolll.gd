extends ButtonSelf

@export var ball: Ball


func _on_pressed() -> void:
	if ball:
		ball.toggle_rolling()
