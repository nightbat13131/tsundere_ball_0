class_name ButtonLevelSelect extends ButtonSelf
# TODO: change state based on unlock conditions
# TODO: enter level button cursors 

const PATH_FACE = 'uid://dp6bw3nvdfa4g'
const PATH_CURSOR_ENTER_LEVEL = ''
static var master_face : FaceTexture

@export var level_info : LevelInfo
var _face : FaceTexture

func _ready() -> void:
	super._ready()
	#_face = load(PATH_FACE)
	#_face = _face.duplicate(true)
	set_button_icon(get_face())
	if level_info != null:
		level_info._ready()
		level_info.changed.connect(_on_level_info_change)
		_on_level_info_change()
	else:
		push_error(self, " missing Level_Info")

func _on_pressed() -> void:
	if level_info:
		LevelSelect.request_level(level_info)
	else:
		push_warning("Level Select button has no Level Info")

func _on_level_info_change() -> void:
	print(self)
	get_face().set_emotion(level_info.get_emotion())

func get_face() -> FaceTexture:
	if master_face == null:
		master_face = load(PATH_FACE)
	if _face == null:
		if master_face:
			_face = master_face.duplicate(true)
	return _face
