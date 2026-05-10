class_name GameRoot extends Node2D

@export var _initial_level: LevelInfo

@export var ui_context: GUIDEMappingContext
@export var pc_controler_context: GUIDEMappingContext
@export var contoler_actions : Array[GUIDEAction]
@export var mouse_keyboard_actions: Array[GUIDEAction]

@onready var loading_blocker: LoadingCurtain = %LoadingBlocker
@export var custom_cursors: Array[CustomCursor]
static var _instance : GameRoot

var _mouse_hidden := false:
	set(value):
		if value == _mouse_hidden:
			return
		_mouse_hidden = value
		if _mouse_hidden:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _ready() -> void:
	_instance = self
	if _initial_level:
		_app_load_level()
	else:
		_app_load_no_level()
	for each in custom_cursors:
		each.activate()
	if ui_context:
		GUIDE.enable_mapping_context(ui_context)
	if pc_controler_context:
		GUIDE.enable_mapping_context(pc_controler_context)
		
		for each_con_action in contoler_actions:
			if each_con_action:
				each_con_action.triggered.connect(_controler_detected)
		for each_key_action in mouse_keyboard_actions:
			if each_key_action:
				each_key_action.triggered.connect(_non_controler_detected)
	if !OS.has_feature(&'web'):
			# keep mosue from jumping out of program on browser 
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _app_load_no_level() -> void:
	loading_blocker.on_app_load()
	LevelSelect.request_activate()

func _app_load_level() -> void:
	loading_blocker.force_closed()
	LevelSelect.request_level(_initial_level)
	LevelSelect.request_deactivate()

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

func _controler_detected() -> void:
	_mouse_hidden = true

func _non_controler_detected() -> void:
	_mouse_hidden = false
