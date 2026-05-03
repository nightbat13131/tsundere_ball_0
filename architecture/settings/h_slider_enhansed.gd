class_name HSlider_Enhanced extends HSlider

@export var remote_press : GUIDEAction

func _process(_delta: float) -> void:
	if remote_press.is_triggered():
		print("volume change ", remote_press.value_axis_3d)
		set_value(
			get_value() + get_step() * remote_press.value_axis_3d.x
		)
