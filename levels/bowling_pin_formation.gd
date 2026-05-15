@tool
extends Node2D
# first child is the point of the formation. 

var ball_index := 0
var _point_pos : Vector2
var _row_length := 0
var _row_count := 5
var _here_radis := (Ball.BALL_RADIUS * 2.05)
var _start_direction := Vector2.from_angle( 5* PI/-6.0) * _here_radis

func _ready() -> void:
	if !Engine.is_editor_hint():
		return
	
	_point_pos = get_child(ball_index).position
	
	#var _current_ball : Ball_NPC
	var _current_position : Vector2 = _point_pos
	for row_number in _row_count:
		_row_length += 1
		_current_position =_point_pos + (_start_direction * row_number)
		for col_num in (_row_length):
			if ball_index >= 10:
				return
			
			get_child(ball_index).position = _current_position
			_current_position += Vector2.DOWN * _here_radis
			ball_index += 1
