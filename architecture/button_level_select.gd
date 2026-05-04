class_name ButtonLevelSelect extends ButtonSelf
# TODO: change state based on unlock conditions
# TODO: enter level button cursors 

@export var level_info : LevelInfo

func _ready() -> void:
	super._ready()
	if level_info:
		set_text(level_info.get_level_name())

func _on_pressed() -> void:
	if level_info:
		LevelSelect.request_level(level_info)
	else:
		push_warning("Level Select button has no Level Info")
