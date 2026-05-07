class_name GameRoot extends Node2D

static func request_pause(is_pause: bool) -> void:
	Level.request_pause(is_pause)
	AnimatedSprite_Ball.request_pause(is_pause)
