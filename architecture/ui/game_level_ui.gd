@tool
class_name GameLevelUI extends CanvasLayer

static var _instance : GameLevelUI : get = get_instance
@onready var level_viewport: LevelViewport = %LevelViewport
#@onready var level_anchor: LevelAnchor = %LevelAnchor
@export var action_request_focus : GUIDEAction

const UI_BANNER_HEIGHT = 50
@onready var top_banner: Container = %TopBanner
@export var focus_target : Button

func _ready() -> void:
	if Engine.is_editor_hint():
		top_banner.custom_minimum_size.y = UI_BANNER_HEIGHT
		return
	if action_request_focus:
		action_request_focus.triggered.connect(_on_action_request_focus)
	_instance = self

func _on_action_request_focus() -> void:
	if is_active():
		if focus_target:
			focus_target.grab_focus()

func is_active() -> bool: return is_visible()

func activate() -> void:
	set_physics_process(true)
	show()

func deactivate() -> void:
	if Engine.is_editor_hint():
		return
	hide()
	set_physics_process(false)

func _show_level(level_scene: PackedScene, level_info: LevelInfo) -> void:
	activate()
	var level : Level = level_scene.instantiate()
	level.set_info(level_info)
	level_viewport.add_level(level)
	#level_anchor.add_level(level)

func _clear_old_level() -> void:
	if Engine.is_editor_hint():
		return
	level_viewport.clear_old_level()
	#level_anchor.clear_old_level()

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

static func get_viewport_size() -> Vector2: 
	var a = Vector2.ONE
	a.x = ProjectSettings.get_setting('display/window/size/viewport_width') - UI_BANNER_HEIGHT
	a.y = ProjectSettings.get_setting('display/window/size/viewport_height') - UI_BANNER_HEIGHT*2
	a = a.snapped(Vector2.ONE*16)
	return a
