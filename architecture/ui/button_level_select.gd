class_name ButtonLevelSelect extends ButtonSelf
# TODO: change state based on unlock conditions
# TODO: enter level button cursors 

const FACE_PATH = 'uid://dp6bw3nvdfa4g'

@export var level_info : LevelInfo
var _face : FaceTexture

func _ready() -> void:
	super._ready()
	_face = load(FACE_PATH)
	_face = _face.duplicate(true)
	set_button_icon(_face)
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
	_face.set_emotion(level_info.get_emotion())
