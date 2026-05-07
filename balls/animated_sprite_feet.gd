class_name AnimatedSprite_Feet extends AnimatedSprite2D

const snap_float = TAU / 8
const STILL = &"default"
const WALK = &'walking'
const AVERAGE_SPEED = 100.0

var _speed: float = -0.1: set = _set_speed

static var _instances : Array[AnimatedSprite_Feet]

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
	set_global_rotation(radian)

func _request_pause() -> void:
	pause()

static func request_pause(_is_pause) -> void:
	# TODO: not working
	for each in _instances: 
		each._request_pause()
	
