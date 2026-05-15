class_name TextureRect_Goal extends TextureRect

signal request_reorder

var _goal: Goal_Info

func _ready() -> void: set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT)

func get_sort_order() -> int: 
	if _goal:
		return _goal.get_sort_order()
	return 0

func apply_goal(goal: Goal_Info) -> void:
	_goal = goal
	set_texture(_goal.get_goal_icon())
	_goal.update_icon.connect(_on_update_icon)

func _on_update_icon(icon: Texture2D) -> void:
	set_texture(icon)
	request_reorder.emit()
