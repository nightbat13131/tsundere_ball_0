extends SpinBox

@export var ball : AnimatedSprite_Ball

func _ready() -> void:
	value_changed.connect(_on_value_changed)

func _on_value_changed(value_: float) -> void:
	queue_redraw()
	if ball:
		ball._roll_direction(deg_to_rad(value_))


func _draw() -> void:
	draw_line(
		Vector2.ZERO, 
		Vector2.from_angle(deg_to_rad(value)) * 100, 
		Color.FIREBRICK, 
		5.0
	)
