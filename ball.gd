class_name Ball extends Node2D

@onready var animated_sprite_ball: AnimatedSprite_Ball = %AnimatedSprite_Ball

func rolling_speed(speed: float) -> void:
	animated_sprite_ball.speed = speed

func roll_direction(radian: float) -> void:
	animated_sprite_ball.roll_direction(radian)

func toggle_rolling() -> void: animated_sprite_ball.is_rolling = !animated_sprite_ball.is_rolling
