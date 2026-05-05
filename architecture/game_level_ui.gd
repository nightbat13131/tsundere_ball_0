class_name GameLevelUI extends CanvasLayer

static var _instance : GameLevelUI : get = get_instance
@onready var level_viewport: LevelViewport = %LevelViewport


func _ready() -> void:
	#deactivate()
	_instance = self

func activate() -> void:
	set_physics_process(true)
	show()

func deactivate() -> void:
	hide()
	set_physics_process(false)

func _show_level(level: PackedScene) -> void:
	activate()
	level_viewport.add_level(level.instantiate())

static func try_deactivate() -> void:
	if get_instance():
			get_instance().deactivate()

static func get_instance() -> GameLevelUI: return _instance

static func show_level(level: PackedScene) -> void:
	if level == null:
		push_error("GameLevelUI.show_level called with a null level")
	else: 
		if get_instance():
			get_instance()._show_level(level)

static func request_deactivate() -> void:
	if get_instance():
		get_instance().deactivate()

static func request_subviewport() -> SubViewport: 
	if get_instance():
		return get_instance().level_viewport
	return null
