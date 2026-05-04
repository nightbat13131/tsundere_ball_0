@tool
class_name Portrait extends TextureRect

enum Emotions {IDLE = 0, MAD = 1, BLUSHING = 2}

const BASE_DURATION = 1.0

static var _instance : Portrait

@export var idle: CompressedTexture2D
@export var mad: CompressedTexture2D
@export var blushing: CompressedTexture2D

var emote_remaining := 0.0

func _ready() -> void:
	_instance = self
	request_emotion(Emotions.IDLE)

func _process(delta: float) -> void:
	if emote_remaining > 0.0:
		emote_remaining -= delta
		if emote_remaining <= 0.0:
			_request_emotion(Emotions.IDLE)

func _request_emotion(emotion: Emotions) -> void:
	var tex : CompressedTexture2D
	match emotion:
		Emotions.MAD:
			if mad:
				tex = mad
		Emotions.BLUSHING:
			if blushing:
				tex = blushing
	emote_remaining = BASE_DURATION
	if tex == null:
		tex = idle
		emote_remaining = 0.0
	set_texture(tex)

static func request_emotion(emotion: Emotions) -> void:
	if _instance:
		_instance._request_emotion(emotion)
