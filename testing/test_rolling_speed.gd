extends SpinBox

@export var ball : AnimatedSprite_Ball

func _ready() -> void:
	value_changed.connect(_on_value_changed)

func _on_value_changed(value_: float) -> void:
	if ball:
		ball._set_speed(value_)
