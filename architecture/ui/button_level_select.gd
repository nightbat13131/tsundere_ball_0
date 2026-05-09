class_name ButtonLevelSelect extends ButtonSelf
# TODO: change state based on unlock conditions
# TODO: enter level button cursors 

const PATH_FACE = 'uid://dp6bw3nvdfa4g'
static var master_face : FaceTexture

const PATH_CURSOR_ENTER_LEVEL = 'uid://bgs66genfal2j'
const PATH_CURSOR_LEVEL_BLOCKED = 'uid://dyrjqnpjmmggu'
static var cursor_enter_level : CustomCursor
static var cursor_level_blocked : CustomCursor

@export var level_info : LevelInfo
var _face : FaceTexture

func _ready() -> void:
	super._ready()
	set_button_icon(get_face())
	if level_info != null:
		level_info._ready()
		level_info.changed.connect(_on_level_info_change)
		_on_level_info_change()
	else:
		push_error(self, " missing Level_Info")

func _on_pressed() -> void:
	if level_info:
		if !level_info.is_locked():
			LevelSelect.request_level(level_info)
	else:
		push_warning("Level Select button has no Level Info")

func _on_level_info_change() -> void:
	get_face().set_emotion(level_info.get_emotion())
	if cursor_enter_level == null:
		cursor_enter_level = load(PATH_CURSOR_ENTER_LEVEL)
	if cursor_level_blocked == null:
		cursor_level_blocked = load(PATH_CURSOR_LEVEL_BLOCKED)
	if level_info.is_locked():
		if cursor_level_blocked:
			cursor_level_blocked.apply_to(self)
	else:
		if cursor_enter_level:
			cursor_enter_level.apply_to(self)

func get_face() -> FaceTexture:
	if master_face == null:
		master_face = load(PATH_FACE)
	if _face == null:
		if master_face:
			_face = master_face.duplicate(true)
	return _face
