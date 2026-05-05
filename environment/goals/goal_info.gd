class_name Goal_Info extends Resource

signal update_icon(texture)

## Aim for 36*36 or less
@export var ui_icon_init: Texture2D
## Aim for 36*36 or less
@export var ui_icon_failed: Texture2D
# lower number goes first
@export var ui_icon_success: Texture2D
@export var sort_order := 1

var _is_success := true

func get_goal_icon() -> Texture2D:
	return ui_icon_init

func broke() -> void:
	_is_success = false
	update_icon.emit(ui_icon_failed)
