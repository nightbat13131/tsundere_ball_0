@tool
extends StaticBody2d_Enhanced

func _ready() -> void:
	UTILITIES.apply_z_layer(self, UTILITIES.Z_Indexes.DECORATIONS)
	if Engine.is_editor_hint():
		_engine_align()
	else:
		super._ready()

func _engine_align() -> void:
	for each_child in get_children():
		#if each_child is Sprite2D:
				each_child.global_position = each_child.global_position.snapped(Vector2.ONE*2)
