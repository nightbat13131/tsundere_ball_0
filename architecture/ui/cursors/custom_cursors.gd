class_name CustomCursor extends Resource

@export var cursor_type: Input.CursorShape
@export var icon: Texture
@export var offset := Vector2.ZERO

func activate() -> void:
	if icon:
		Input.set_custom_mouse_cursor(
			icon, 
			cursor_type, 
			offset
			)

func apply_to(node: Control) -> void:
	node.set_default_cursor_shape(cursor_type as Control.CursorShape)
