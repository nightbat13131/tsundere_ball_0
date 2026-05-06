class_name Ball_Player_Walking extends Ball
# if wasd then walk instead of roll mode

# https://www.youtube.com/watch?v=tgrDkFdEK0I
## there was a problem with Ball_Player going odd directions if shot while moving, but turning off rotation seems to have solved this problem.

const DEFAULT_POS := Vector2.INF
const COLOR_OTHER = Color(Color.GRAY, .50)

const CANCLE_PAUSE_DURATION := .5
const MAX_POWER := 1600.0
const MIN_POWER := MAX_POWER * .05

const LEFT_MOUSE_CLICK = &"left_click"

const EVENT_MOUSE_PRESSED = &'mouse_pressed'
const EVENT_MOUSE_RELEASED = &'mouse_released'

var cancle_pause := 0.0
var cycle_mod := 1

static var _instance : Ball_Player_Walking

@onready var state_chart: StateChart = %StateChart

@export_category("G.U.I.D.E.")
@export var pc_controler_context: GUIDEMappingContext
@export var action_walking: GUIDEAction
@export var action_cancle_ball: GUIDEAction
@export var action_mouse_pressed : GUIDEAction
@export var action_mouse_release : GUIDEAction

var global_mouse_start := DEFAULT_POS
var global_mouse_end := DEFAULT_POS

func _ready() -> void:
	super._ready()
	_instance = self
	set_z_index(UTILITIES.Z_Indexes.BALL_PLAYER as int)
	set_z_as_relative(false)
	set_y_sort_enabled(false) 
	if pc_controler_context:
		GUIDE.enable_mapping_context(pc_controler_context)
		if action_mouse_pressed:
			action_mouse_pressed.triggered.connect(_send_event.bind(EVENT_MOUSE_PRESSED))
		if action_mouse_release:
			action_mouse_release.triggered.connect(_send_event.bind(EVENT_MOUSE_RELEASED))

	set_collision_layer_value(Ball.LAYER_PC, true)
	set_collision_mask_value(Ball.LAYER_PC_WALL, true)
	_set_shader_parameter(UTILITIES.SHADER_OUTLINE_COLOR, UTILITIES.COLOR_BORDER_BOUNCY)
	_set_shader_parameter(UTILITIES.SHADER_MODULATE_COLOR, UTILITIES.COLOR_PLAYER) 

func _get_usable_power() -> float:
	var out : float = (global_mouse_start - global_mouse_end).length() 
	## short doesn't count
	if out < BALL_RADIUS:
		return 0.0
	out -= BALL_RADIUS
	out *= 12
	return clampf(out, MIN_POWER, MAX_POWER)

func _get_power_ratio() -> float: 
	#prints(_power, _get_usable_power(),  MAX_POWER, _get_usable_power() / MAX_POWER)
	return _get_usable_power() / MAX_POWER


func get_shot_angle_vector() -> Vector2:
	if global_mouse_start != DEFAULT_POS and global_mouse_end != DEFAULT_POS:
		return global_mouse_start - global_mouse_end
	return DEFAULT_POS


func _cancle_shoot() -> void:
	global_mouse_end = DEFAULT_POS
	global_mouse_start = DEFAULT_POS
	cancle_pause = CANCLE_PAUSE_DURATION
	queue_redraw()

func _draw() -> void:
	if cancle_pause > 0.0:
		return
	var visable_power = _get_usable_power()  * sin(_get_power_ratio()) * .1
	if visable_power == NAN:
		return
	visable_power = max(BALL_RADIUS, visable_power)
	var color_power = Color.from_hsv( (1.0-_get_power_ratio()) *.33, 1.0, 1.0, .5)

	var direction = get_shot_angle_vector()
	if direction == DEFAULT_POS:
		return
	direction = direction.normalized()
	draw_circle(to_local(global_mouse_start), BALL_RADIUS, COLOR_OTHER, false, 2)
	draw_line(to_local(global_mouse_start), to_local(global_mouse_end), COLOR_OTHER, 2) # mouse line
	draw_polygon(
		[direction*visable_power, direction.rotated(- PI*.5)*BALL_RADIUS, direction.rotated( PI*.5)*BALL_RADIUS,  ], [color_power]
			)

func _send_event(event: String) -> void:
	print(event)
	if state_chart:
		state_chart.send_event(event)
	else:
		push_error(self, " has no State Chart")


func _on_waiting_walk_state_processing(delta: float) -> void:
	pass # Replace with function body.

func _on_waiting_roll_state_processing(delta: float) -> void:
		
	if action_cancle_ball.is_triggered():
		_cancle_shoot()
		return
	if cancle_pause > 0.0:
		cancle_pause -= delta
		return
	_rolling_movement(delta)





func _on_aiming_state_entered() -> void: global_mouse_start = get_global_mouse_position()

func _on_aiming_state_exited() -> void: global_mouse_end = get_global_mouse_position()


func _on_try_shoot_state_entered() -> void: 
	apply_central_impulse(get_shot_angle_vector().normalized() * _get_usable_power())
	global_mouse_end = DEFAULT_POS
	global_mouse_start = DEFAULT_POS


func _on_aiming_state_processing(delta: float) -> void:
	pass # Replace with function body.
