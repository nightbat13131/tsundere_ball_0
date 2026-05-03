class_name Ball extends RigidBody2D

@onready var animated_sprite_ball: AnimatedSprite_Ball = %AnimatedSprite_Ball

func rolling_speed(speed: float) -> void:
	animated_sprite_ball.speed = speed

func roll_direction(radian: float) -> void:
	animated_sprite_ball.roll_direction(radian)

func toggle_rolling() -> void: animated_sprite_ball.is_rolling = !animated_sprite_ball.is_rolling

func _process(delta: float) -> void:
	animated_sprite_ball.set_velocity(linear_velocity)
	animated_sprite_ball.rotation = rotation *- 1
	#print(linear_velocity, linear_velocity.snappedf(0.1), linear_velocity.snappedf(0.1).length())
	#roll_direction(linear_velocity.angle())
	#rolling_speed(linear_velocity.snappedf(0.1).length())
