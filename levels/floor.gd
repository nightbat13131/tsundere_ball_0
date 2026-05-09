@tool
class_name Floor extends TextureRect

func _ready() -> void:
	position = position.snapped(Vector2.ONE * 8)
	size = size.snapped(Vector2.ONE*8)
	set_expand_mode(TextureRect.EXPAND_IGNORE_SIZE)
	set_stretch_mode(TextureRect.STRETCH_TILE)
	
