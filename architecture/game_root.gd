class_name GameRoot extends Node2D

@export var ui_context: GUIDEMappingContext

@onready var loading_blocker: LoadingScreen = %LoadingBlocker

static var _instance : GameRoot

func _ready() -> void:
	_instance = self
	if ui_context:
		GUIDE.enable_mapping_context(ui_context)
	loading_blocker.on_app_load()

static func request_pause(is_pause: bool) -> void:
	Level.request_pause(is_pause)
	AnimatedSprite_Ball.request_pause(is_pause)

static func request_map_view() -> void:
	Level.request_pause(true)
	if _instance:
		_instance.loading_blocker.close_curtain()
		await _instance.loading_blocker.curtain_closed
	LevelSelect.request_activate()
	_instance.loading_blocker.open_curtain()
	GameLevelUI.request_deactivate()
	#SoundManager
