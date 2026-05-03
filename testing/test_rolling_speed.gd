extends SpinBox



@export var ball : Ball

func _ready() -> void:
	value_changed.connect(_on_value_changed)

func _on_value_changed(value: float) -> void:
	if ball:
		ball.rolling_speed(value)
