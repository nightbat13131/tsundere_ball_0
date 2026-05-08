class_name GameRoot extends Node2D

@export var ui_context: GUIDEMappingContext

@onready var loading_blocker: LoadingCurtain = %LoadingBlocker

static var _instance : GameRoot

func _ready() -> void:
	_instance = self
	if ui_context:
		GUIDE.enable_mapping_context(ui_context)
	loading_blocker.on_app_load()

static func request_pause(is_pause: bool) -> void:
	if _instance:
		_instance.get_tree().paused = is_pause
	AnimatedSprite_Ball.request_pause(is_pause)

static func request_map_view() -> void:
	if _instance:
		_instance.loading_blocker.close_curtain()
		await _instance.loading_blocker.curtain_closed
	GameLevelUI.clear_old_level()
	LevelSelect.request_activate()
	LoadingCurtain.request_open()
	GameLevelUI.request_deactivate()
