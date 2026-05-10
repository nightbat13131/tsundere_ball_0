@tool
class_name LevelAnchor extends Control

func _ready() -> void:
	set_custom_minimum_size(GameLevelUI.get_viewport_size())

func clear_old_level() -> void:
	for old in get_children():
		old.queue_free()

func add_level(level: Level) -> void:
	clear_old_level()
	add_child(level)
