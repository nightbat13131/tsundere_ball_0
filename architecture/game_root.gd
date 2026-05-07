class_name GameRoot extends Node2D

@export var ui_context: GUIDEMappingContext


func _ready() -> void:
	if ui_context:
		GUIDE.enable_mapping_context(ui_context)

static func request_pause(is_pause: bool) -> void:
	Level.request_pause(is_pause)
	AnimatedSprite_Ball.request_pause(is_pause)
