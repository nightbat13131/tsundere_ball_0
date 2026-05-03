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

var speed: float = -0.1:
	set(value):
		#print(self, value)
		value = abs(value)
		if value == speed:
			return
		speed = value
		speed_scale = speed / AVERAGE_SPEED

func set_velocity(velocity: Vector2) -> void:
	roll_direction(velocity.angle())
	speed = velocity.length()

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
	var current_frame = get_frame()
	var current_progress = get_frame_progress()
	play(animation_)
	set_frame_and_progress(current_frame, current_progress)

	

#func _on_animation_looped() -> void:
	#if !is_rolling:
		#play(STILL)
