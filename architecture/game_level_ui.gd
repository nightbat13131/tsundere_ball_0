class_name GameLevelUI extends CanvasLayer

static var _instance : GameLevelUI : get = get_instance
@onready var level_viewport: LevelViewport = %LevelViewport

const UI_BANNER_HEIGHT = 40

func _ready() -> void:
	#deactivate()
	_instance = self

func activate() -> void:
	set_physics_process(true)
	show()

func deactivate() -> void:
	hide()
	set_physics_process(false)

func _show_level(level_scene: PackedScene, level_info: LevelInfo) -> void:
	activate()
	var level : Level = level_scene.instantiate()
	level.set_info(level_info)
	level_viewport.add_level(level)

func _clear_old_level() -> void:
	level_viewport.clear_old_level()

static func try_deactivate() -> void:
	if get_instance():
			get_instance().deactivate()

static func get_instance() -> GameLevelUI: return _instance

static func show_level(level_scene: PackedScene, level_info: LevelInfo) -> void:
	if level_scene == null:
		push_error("GameLevelUI.show_level called with a null level")
	else: 
		if get_instance():
			get_instance()._show_level(level_scene, level_info)
			GameRoot.request_pause.call_deferred(false)

static func clear_old_level() -> void:
	if get_instance():
		get_instance()._clear_old_level()

static func request_deactivate() -> void:
	if get_instance():
		get_instance().deactivate()

static func request_subviewport() -> SubViewport: 
	if get_instance():
		return get_instance().level_viewport
	return null
