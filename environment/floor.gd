@tool
class_name Floor extends TextureRect

const CURSOR_PATH = 'uid://3vj7d6h5jtmr'

static var cursor : CustomCursor


func _ready() -> void:
	position = position.snapped(Vector2.ONE * 8)
	size = size.snapped(Vector2.ONE*8)
	set_expand_mode(TextureRect.EXPAND_IGNORE_SIZE)
	set_stretch_mode(TextureRect.STRETCH_TILE)
	if Engine.is_editor_hint():
		return
	if cursor == null:
		cursor = load(CURSOR_PATH)
	if cursor:
		cursor.apply_to(self)
