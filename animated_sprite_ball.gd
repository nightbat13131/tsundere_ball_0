class_name AnimatedSprite_Ball extends AnimatedSprite2D


const snap_float = TAU / 8
const STILL = &"default"
const AVERAGE_SPEED = 50.0

var is_rolling := false:
	set(value):
		if value == is_rolling:
			return
		is_rolling = value
		if is_rolling:
			play()
		else:
			pause()

var speed: float = 0.0:
	set(value):
		if value == speed:
			return
		speed = value
		speed_scale = speed / AVERAGE_SPEED

func _ready() -> void:
	#animation_looped.connect(_on_animation_looped)
	pass

func roll_direction(radian: float) -> void:
	is_rolling = true
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
	#prints(direction, animation_)
	play(animation_)

#func _on_animation_looped() -> void:
	#if !is_rolling:
		#play(STILL)
