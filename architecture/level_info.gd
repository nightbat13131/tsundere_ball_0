class_name LevelInfo extends Resource

@export var level_name: String: get = get_level_name
@export var level_uid: String : get = get_level_path
#@export var view_mode := LevelViewport.Modes.NA
#@export var starting_gold: float = 1000



func get_level_name() -> String:
	if level_name:
		return level_name
	return "Nameless Level"

func get_level_path() -> String: return level_uid

#func get_levelviewport_mode() -> LevelViewport.Modes: return view_mode

#func on_level_start() -> void: 
	#GoldManager.on_level_start(starting_gold)
