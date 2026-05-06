@tool
class_name Level extends Node2D

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	GoalTracker.level_start()

func _draw() -> void:
	
	var window_size := Vector2.ONE
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
	
