class_name Ball_Player_Walking extends Ball
# if wasd then walk instead of roll mode

# https://www.youtube.com/watch?v=tgrDkFdEK0I
## there was a problem with Ball_Player going odd directions if shot while moving, but turning off rotation seems to have solved this problem.

const DEFAULT_POS := Vector2.INF
const COLOR_OTHER = Color(Color.GRAY, .50)

const CANCLE_PAUSE_DURATION := .5
const MAX_POWER := 1600.0
const MIN_POWER := MAX_POWER * .05

const EVENT_MOUSE_PRESSED = &'mouse_pressed'
const EVENT_TRY_SHOOT = &'try_shoot'
const EVENT_CANCLE_SHOOT = &'cancle_shoot'
const EVENT_SHOOT_COMPLETE = &"shot_done"
const EVENT_WALKING_TRIED = &'walk_around'
const EVENT_JOYSTICK_AIMING = &'joystick_aiming'

const MASS_ROLLING := 2.0 # push around the other balls, (I think NPC balls have a mass of 1.0)
const MASS_WALKING := .01 # get bullied by the other balls
const DAMP_ROLLING := .5 # drift around before coming to a stop
const DAMP_WALKING := 4 # come to a stop relatively quick

static var _instance : Ball_Player_Walking

@onready var state_chart: StateChart = %StateChart
@onready var state_walk: AtomicState = %WalkMode
@onready var state_aiming: CompoundState = %Aiming
@onready var state_aiming_mouse: AtomicState = %AimingMouse
@onready var state_aiming_joystick: AtomicState = %AimingJoystick

@onready var animated_sprite_feet: AnimatedSprite_Feet = %AnimatedSprite_Feet

@export_category("G.U.I.D.E.")
@export var pc_controler_context: GUIDEMappingContext
@export var action_walking: GUIDEAction
@export var action_cancle_ball: GUIDEAction
@export var action_start_mouse_aim : GUIDEAction
@export var action_try_shoot : GUIDEAction
@export var action_joystick_aim : GUIDEAction

var global_mouse_start := DEFAULT_POS
var global_mouse_end := DEFAULT_POS

var _screen_center := Vector2.ONE * 100.0 # TODO udpate on screen resize

var need_stop = true
var nees_a = false

func _ready() -> void:
	super._ready()
	_instance = self
	tree_exiting.connect(_on_tree_exiting)
	set_z_index(UTILITIES.Z_Indexes.BALL_PLAYER as int)
	set_z_as_relative(false)
	set_y_sort_enabled(false) 
	if pc_controler_context:
		GUIDE.enable_mapping_context(pc_controler_context)
		if action_start_mouse_aim:
			action_start_mouse_aim.triggered.connect(_send_event.bind(EVENT_MOUSE_PRESSED))
		if action_try_shoot:
			action_try_shoot.triggered.connect(_send_event.bind(EVENT_TRY_SHOOT))
		if action_cancle_ball:
			action_cancle_ball.triggered.connect(_send_event.bind(EVENT_CANCLE_SHOOT))
		if action_joystick_aim:
			action_joystick_aim.triggered.connect(_send_event.bind(EVENT_JOYSTICK_AIMING))
		if action_walking:
			action_walking.triggered.connect(_on_action_walking_triggered)
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	_on_viewport_size_changed()
	set_collision_layer_value(Ball.LAYER_PC, true)
	set_collision_mask_value(Ball.LAYER_PC_WALL, true)
	_set_shader_parameter(UTILITIES.SHADER_OUTLINE_COLOR, UTILITIES.COLOR_BORDER_BOUNCY)
	_set_shader_parameter(UTILITIES.SHADER_MODULATE_COLOR, UTILITIES.COLOR_PLAYER) 

static func request_pause(is_pause) -> void:
	if _instance:
		if is_pause:
			GUIDE.disable_mapping_context(_instance.pc_controler_context)
		else:
			GUIDE.enable_mapping_context(_instance.pc_controler_context)

func _process(delta: float) -> void:
	super._process(delta)
	animated_sprite_feet.set_velocity(linear_velocity)

func _get_usable_power() -> float:
	var out : float 
	if state_aiming_mouse:
		out = (global_mouse_start - global_mouse_end).length() 
	elif state_aiming_joystick:
		if action_joystick_aim.is_triggered():
			out = action_joystick_aim.value_axis_2d.length() * MAX_POWER
	## short doesn't count
	if out < BALL_RADIUS:
		return 0.0
	out -= BALL_RADIUS
	out *= 12
	return clampf(out, MIN_POWER, MAX_POWER)

func _get_power_ratio() -> float: 
	#prints(_power, _get_usable_power(),  MAX_POWER, _get_usable_power() / MAX_POWER)
	return (_get_usable_power()-MIN_POWER) / (MAX_POWER - MIN_POWER)

func get_shot_angle_vector() -> Vector2:
	if global_mouse_start != DEFAULT_POS and global_mouse_end != DEFAULT_POS:
		return global_mouse_start - global_mouse_end
	return DEFAULT_POS

func _draw() -> void:
	if state_aiming.active: 
		_draw_power_indicator() 
		if state_aiming_mouse.active:
			_draw_mouse_aim()
		elif state_aiming_joystick.active:
			_draw_joystick_aim()

func _draw_power_indicator() -> void:
	var local_start : Vector2 = to_local(global_mouse_start)
	var visable_power := _get_power_ratio()
	if is_equal_approx(visable_power, 0.0):
		return
	visable_power *= sin(_get_power_ratio())
	visable_power =  BALL_RADIUS + (visable_power * BALL_RADIUS*8)
	var direction = get_shot_angle_vector()
	if direction == DEFAULT_POS:
		return
	direction = direction.normalized()
	var color_power = Color.from_hsv( (1.0-_get_power_ratio()) *.33, 1.0, 1.0, .5)
	draw_polygon(
		[direction*visable_power, direction.rotated(- PI*.5)*BALL_RADIUS, direction.rotated( PI*.5)*BALL_RADIUS,  ], [color_power]
			) 

func _draw_joystick_aim() -> void:
	var local_start := to_local(_screen_center)
	draw_circle(local_start, BALL_RADIUS, COLOR_OTHER, false, 5)

func _draw_mouse_aim() -> void:
	var local_start : Vector2 = to_local(global_mouse_start)
	draw_circle(local_start, BALL_RADIUS, COLOR_OTHER, false, 5)
	var direction = get_shot_angle_vector()
	if direction == DEFAULT_POS:
		return
	direction = direction.normalized()
	## Mouse line
	draw_line(local_start - direction*BALL_RADIUS, 
		to_local(global_mouse_end), 
		COLOR_OTHER, 2)

func _send_event(event: String) -> void:
	prints(event)
	if state_chart:
		state_chart.send_event(event)
	else:
		push_error(self, " has no State Chart")

func _on_action_walking_triggered() -> void:
	_send_event(EVENT_WALKING_TRIED)
	nees_a = true
	if state_walk.active:
		apply_central_impulse(action_walking.value_axis_2d.normalized() * get_mass() * 10.0)

func _on_roll_mode_state_entered() -> void: 
	animated_sprite_feet.hide()
	set_mass(MASS_ROLLING)
	set_linear_damp(DAMP_ROLLING)

func _on_roll_mode_state_exited() -> void: animated_sprite_feet.show()

func _on_waiting_roll_state_entered() -> void:
	global_mouse_end = DEFAULT_POS
	global_mouse_start = DEFAULT_POS
	queue_redraw()

func _on_aiming_state_entered() -> void: global_mouse_start = get_global_mouse_position()

func _on_aiming_state_processing(_delta: float) -> void:
	global_mouse_end = get_global_mouse_position()
	queue_redraw()

func _on_try_shoot_state_entered() -> void: 
	queue_redraw()
	_send_event(EVENT_SHOOT_COMPLETE) # so far no conflict with calling this before applying the impulse
	var _power = _get_usable_power()
	if is_equal_approx(_power, 0.0):
		return
	apply_central_impulse(get_shot_angle_vector().normalized() * _power)

func _on_walk_mode_state_entered() -> void: 
	set_mass(MASS_WALKING)
	set_linear_damp(DAMP_WALKING)

func _on_tree_exiting() -> void:
	if _instance == self:
		_instance = null

func _on_viewport_size_changed() -> void: _screen_center = get_viewport_rect().get_center()
