class_name Portrait extends TextureRect

const BASE_DURATION = 2.0

static var _instance : Portrait

@export var face_image : FaceTexture

var emote_remaining := 0.0

func _ready() -> void:
	_instance = self
	face_image.init()
	set_texture(face_image)

func _process(delta: float) -> void:
	if emote_remaining > 0.0:
		emote_remaining -= delta
		if emote_remaining <= 0.0:
			_to_idle()

func _to_idle() -> void:
	var results : FaceTexture.Emotions = GoalTracker.get_score().get_emotion()
	if results == null:
		results = FaceTexture.Emotions.IDLE
	_request_emotion(	results, true)

func _request_emotion(emotion: FaceTexture.Emotions, is_idle:= false) -> void:
	face_image.set_emotion(emotion)
	if is_idle:
		emote_remaining = 0.0
	else: 
		emote_remaining = BASE_DURATION

static func request_emotion(emotion: FaceTexture.Emotions) -> void:
	if _instance:
		_instance._request_emotion(emotion)

static func level_start() -> void:
	if _instance:
		_instance._to_idle.call_deferred()
