@tool
class_name Level extends Node2D

static var _instance

@export var level_end : Trap

var _level_info : LevelInfo

func _ready() -> void:
	_instance = self
	if Engine.is_editor_hint():
		return
	GoalTracker.level_start()
	Portrait.level_start()
	if level_end:
		level_end.used.connect(_on_level_end_start)
		level_end.complete.connect(_on_level_end_complete)
	else:
		push_error(self, "has no level_end")

func set_info(info: LevelInfo) -> void: _level_info = info

func _draw() -> void:
	if !Engine.is_editor_hint():
		return
	if level_end:
		var focus_point = level_end.position
		draw_line(Vector2(1000,1)*focus_point, Vector2(-1000,1)*focus_point, Color.BLUE_VIOLET, 3)
		draw_line(Vector2(1,1000)*focus_point, Vector2(1,-1000)*focus_point, Color.BLUE_VIOLET, 3)
		#(level_end.position, 16, Color.BLUE_VIOLET, false, 2)
	var win_scale : float = ProjectSettings.get_setting('display/window/stretch/scale')
	var window_size := LevelViewport.get_viewport_size() / win_scale
	var ui_size := Vector2(window_size.x, GameLevelUI.UI_BANNER_HEIGHT)
	for points in [
			[Vector2.ZERO, Vector2(1,0)*window_size, Vector2(1,1)*window_size, Vector2(0,1)*window_size, Vector2.ZERO],
			[Vector2.ZERO, Vector2(0,-1)*ui_size, Vector2(1,-1)*ui_size, Vector2(1,0)*ui_size]
			]:
		draw_polyline(points, Color.RED, 4
	)

func _on_level_end_start(thing: Ball) -> void:
	if thing is Ball_Player:
		Portrait.request_emotion(FaceTexture.Emotions.BLUSHING)
		if _level_info: ## so can run level in debug
			_level_info.set_score(GoalTracker.get_score())
	else:
		push_error(thing, "triggered Level._on_level_end_start instead of a Ball_Player")

func _on_level_end_complete(thing: Ball) -> void:
	if thing is Ball_Player:
		GameRoot.request_map_view()
	else:
		push_error(thing, "triggered Level._on_level_end_start instead of a Ball_Player")
