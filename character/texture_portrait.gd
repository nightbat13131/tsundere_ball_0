@tool
class_name Portrait extends TextureRect

enum Emotions {IDLE = 0, MAD = 1, BLUSHING = 2}

static var _instance : Portrait

@export var idle: CompressedTexture2D
@export var mad: CompressedTexture2D
@export var blushing: CompressedTexture2D

func _ready() -> void:
	_instance = self
	request_emotion(Emotions.IDLE)

func _request_emotion(emotion: Emotions) -> void:
	var tex : CompressedTexture2D
	match emotion:
		Emotions.MAD:
			if mad:
				tex = mad
		Emotions.BLUSHING:
			if blushing:
				tex = blushing
	if tex == null:
		tex = idle
	set_texture(tex)

static func request_emotion(emotion: Emotions) -> void:
	if _instance:
		_instance._request_emotion(emotion)
