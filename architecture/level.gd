@tool
class_name Level extends Node2D

static var _instance

@export var level_end : Trap

func _ready() -> void:
	_instance = self
	if Engine.is_editor_hint():
		return
	GoalTracker.level_start()
	if level_end:
		level_end.used.connect(_on_level_end_start)
		level_end.complete.connect(_on_level_end_complete)
	else:
		push_error(self, "has no level_end")

func _draw() -> void:
	var win_scale : float = ProjectSettings.get_setting('display/window/stretch/scale')
	var window_size := Vector2.ONE / win_scale
	window_size.x *= ProjectSettings.get_setting('display/window/size/viewport_width')
	window_size.y *= ProjectSettings.get_setting('display/window/size/viewport_height')
	
	var ui_size := Vector2(window_size.x, 36.0)
	window_size.y -= ui_size.y
	for points in [
			[Vector2.ZERO, Vector2(1,0)*window_size, Vector2(1,1)*window_size, Vector2(0,1)*window_size, Vector2.ZERO],
			[Vector2.ZERO, Vector2(0,-1)*ui_size, Vector2(1,-1)*ui_size, Vector2(1,0)*ui_size]
			]:
		draw_polyline(points, Color.RED, 4
	)

func _on_level_end_start(thing: Ball) -> void:
	if thing is Ball_Player:
		Portrait.request_emotion(Portrait.Emotions.BLUSHING)
	else:
		push_error(thing, "triggered Level._on_level_end_start instead of a Ball_Player")

func _on_level_end_complete(thing: Ball) -> void:
	if thing is Ball_Player:
		GameRoot.request_map_view()
	else:
		push_error(thing, "triggered Level._on_level_end_start instead of a Ball_Player")
