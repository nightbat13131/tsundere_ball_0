class_name AnimatedSprite_Ball extends AnimatedSprite2D

const snap_float = TAU / 8
const STILL = &"default"
const AVERAGE_SPEED = 50.0

var _speed: float = -0.1: set = _set_speed
var _is_frozen := false

static var _instances : Array[AnimatedSprite_Ball]

func _ready() -> void:
	_instances.append(self)
	tree_exiting.connect(_instances.erase.bind(self))

func _set_speed(speed: float) -> void:
	speed = abs(speed)
	if _speed == speed:
		return
	_speed = speed
	speed_scale = _speed / AVERAGE_SPEED

func set_velocity(velocity: Vector2) -> void:
	_roll_direction(velocity.angle())
	_set_speed(velocity.length())

func _roll_direction(radian: float) -> void:
	var direction := Vector2.from_angle(radian).normalized()
	direction = direction.snappedf(snap_float)
	var animation_ := ""
	if direction.y > 0:
		animation_ += "s"
	elif direction.y < 0:
		animation_ += "n"
	if direction.x > 0:
		animation_ += "e"
	elif direction.x < 0:
		animation_ += "w"
	var current_frame = get_frame()
	var current_progress = get_frame_progress()
	play(animation_)
	set_frame_and_progress(current_frame, current_progress)

func freeze() -> void: 
	if _is_frozen:
		return
	_is_frozen = true
	pause()

func _request_pause() -> void:
	if !_is_frozen:
		pause()

static func request_pause(_is_pause) -> void:
	# TODO: not working
	for each in _instances: 
		each._request_pause()
	
