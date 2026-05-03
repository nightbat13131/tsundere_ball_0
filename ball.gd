class_name Ball_Player extends Ball
# https://www.youtube.com/watch?v=tgrDkFdEK0I

var power := 0.0

func _process(delta: float) -> void:
	super._process(delta)
	queue_redraw()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		power += delta
	else:
		if power > 0.0:
			_shoot_0(get_local_mouse_position()*-1)

func _shoot_0(direction: Vector2) -> void:
	#apply_central_impulse(Vector2.RIGHT * power * 100)
	set_angular_velocity(0)
	apply_central_impulse(direction.normalized() * power * 100)
	power = 0.0
	
	pass

func _draw() -> void:
	draw_line(Vector2.ZERO, get_local_mouse_position(), Color.AQUAMARINE, 2 )
	draw_line(Vector2.ZERO, Vector2.from_angle((get_local_mouse_position()*-1).angle()) *20,Color.RED)


#region Test Interfaces

func rolling_speed(speed: float) -> void: animated_sprite_ball.speed = speed

func roll_direction(radian: float) -> void: animated_sprite_ball.roll_direction(radian)

func toggle_rolling() -> void: animated_sprite_ball.is_rolling = !animated_sprite_ball.is_rolling
#endregion
