class_name LevelSelect extends CanvasLayer

# https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html

static var _instance: LevelSelect: get = get_instance

static var _level_to_load : LevelInfo
static var _last_laoded: LevelInfo

@onready var sprite_2d: Sprite2D = %Sprite2D

func _ready() -> void:
	activate()
	_instance = self

func activate() -> void:
	set_physics_process(true)
	sprite_2d.hide()
	GameLevelUI.try_deactivate.call_deferred()
	show()

func deactivate() -> void:
	hide()
	set_physics_process(false)

func _process(_delta: float) -> void:
	if !_level_to_load:
		return # not loading a level
	var progress = []
	var status = ResourceLoader.load_threaded_get_status(_level_to_load.get_level_path(), progress)
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
		pass
	elif status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		## wait untill after curtain is closed to make change
		if LoadingCurtain.is_closed():
			GameLevelUI.show_level(ResourceLoader.load_threaded_get(_level_to_load.get_level_path()))
			LoadingCurtain.request_open()
			_loading_done()

func _loading_started(): pass 

func _loading_done() -> void:
	_last_laoded = _level_to_load
	_level_to_load = null
	deactivate()

static func get_instance() -> LevelSelect: return _instance

static func request_level(level_info: LevelInfo) -> void:
	if get_instance(): 
		if _level_to_load:
			push_warning("can not load level {0} as level {1} has already started loading".format([level_info.get_level_name(), _level_to_load.get_level_name()]))
			return
		_level_to_load = level_info
		ResourceLoader.load_threaded_request(_level_to_load.get_level_path())
		get_instance()._loading_started()
		LoadingCurtain.request_close()
	else:
		push_warning("no loader instance to enact thing")

static func request_reload() -> void:
	if _last_laoded:
		request_level(_last_laoded)
	else:
		push_warning("LevelSelect.request_reload no last path to retry")

static func request_activate() -> void:
	if get_instance():
		get_instance().activate()
