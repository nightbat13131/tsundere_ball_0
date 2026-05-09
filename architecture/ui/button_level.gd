class_name LevelSelectButton extends Control

@export var level_info : LevelInfo

@export var face : FaceTexture
@onready var texture_rect: TextureRect = %TextureRect
@onready var texture_button: TextureButton_Enhanced = %TextureButton

func _ready() -> void:
	#super._ready()
	face = face.duplicate(true)
	face.init()
	texture_rect.set_texture(face)
	if level_info:
		level_info.changed.connect(_on_level_info_change)
		_on_level_info_change()
	else: 
		push_error(self, " missing Level_Info")
	texture_button.pressed.connect(_on_pressed)
	
func _on_pressed() -> void:
	if level_info:
		LevelSelect.request_level(level_info)
	else:
		push_warning("Level Select button has no Level Info")

func _on_level_info_change() -> void:
	face.set_emotion(level_info.get_emotion())
