class_name Ball_Player extends Ball
## if mouse is being pressed when walking stopps being pressed, 
## swtiched to aiming mode 

# https://www.youtube.com/watch?v=tgrDkFdEK0I
## there was a problem with Ball_Player going odd directions if shot while moving, but turning off rotation seems to have solved this problem.

const COLOR_OTHER = Color(Color.GRAY, .50)

const CANCLE_PAUSE_DURATION := .5
const MAX_POWER := 1600.0
const MIN_POWER := MAX_POWER * .05

const KEY_ROLL_COOLDOWN = &'RollCoolDown'

const EVENT_MOUSE_PRESSED = &'mouse_pressed'
const EVENT_TRY_ROLL = &'try_shoot'
const EVENT_CANCLE_SHOOT = &'cancle_shoot'
const EVENT_SHOOT_COMPLETE = &"shot_done"
const EVENT_WALKING_WASD = &'walk_around_wasd'
const EVENT_WALKING_JOYSTICK = &'walk_around_joystick'
const EVENT_NOT_WALKING = &'not_walking'
const EVENT_CAPTURED = &'captured'
const EVENT_TELEPORTED = &'teleported'
const EVENT_REMOTE_FLING = &'remote_fling'
const EVENT_FLING_COMPLETE = &'fling_complete'

const EVENT_JOYSTICK_AIMING = &'joystick_aiming'
const EVENT_CANCLE_JOYSTICK_AIM = &'cancle_joystick_aiming'

const MASS_ROLLING := 2.0 # push around the other balls, (I think NPC balls have a mass of 1.0)
const MASS_WALKING := .01 # get bullied by the other balls
const DAMP_ROLLING := .5 # drift around before coming to a stop
const DAMP_WALKING := 4 # come to a stop relatively quick

static var _instance : Ball_Player

var global_mouse_start := DEFAULT_POS
var global_mouse_end := DEFAULT_POS

const DEFAULT_ROLL_COOLDONW := .50
var remaining_roll_cooldown := 0.0
var _remote_direction_deg : int = 0
var _remote_power_mod : float = 0.0

@onready var state_chart: StateChart = %StateChart
@onready var state_walk: CompoundState = %WalkMode
@onready var state_aiming: CompoundState = %Aiming
@onready var state_aiming_mouse: CompoundState = %Mouse
@onready var state_aiming_joystick: CompoundState =  %Joystick
@onready var state_captured: AtomicState = %Captured
@onready var drawing_node: DrawingNode = %drawing_node

@onready var animated_sprite_feet: AnimatedSprite_Feet = %AnimatedSprite_Feet

@export_category("G.U.I.D.E.")
@export var pc_controler_context: GUIDEMappingContext
@export var action_walking_wasd: GUIDEAction
@export var action_walking_controler: GUIDEAction
@export var action_cancle_ball: GUIDEAction
@export var action_start_mouse_aim : GUIDEAction
@export var action_joystick_aim : GUIDEAction
@export var action_try_roll_mouse : GUIDEAction
@export var action_try_roll_controler : GUIDEAction

@export_category("Cursors") 
@export var mouse_unpressed : CustomCursor
@export var mouse_pressed : CustomCursor

func _ready() -> void:
	super._ready()
	_instance = self
	tree_exiting.connect(_on_tree_exiting)

	UTILITIES.apply_z_layer(self, UTILITIES.Z_Indexes.BALL_PLAYER)
	if pc_controler_context:
		GUIDE.enable_mapping_context(pc_controler_context)
		if action_start_mouse_aim:
			action_start_mouse_aim.triggered.connect(_send_event.bind(EVENT_MOUSE_PRESSED))
		if action_joystick_aim:
			action_joystick_aim.triggered.connect(_send_event.bind(EVENT_JOYSTICK_AIMING))

		if action_try_roll_mouse:
			action_try_roll_mouse.triggered.connect(_send_event.bind(EVENT_TRY_ROLL))
		if action_try_roll_controler:
			action_try_roll_controler.triggered.connect(_send_event.bind(EVENT_TRY_ROLL))

		if action_cancle_ball:
			action_cancle_ball.triggered.connect(_send_event.bind(EVENT_CANCLE_SHOOT))

		if action_walking_wasd:
			action_walking_wasd.triggered.connect(_send_event.bind(EVENT_WALKING_WASD))
		if action_walking_controler:
			action_walking_controler.triggered.connect(_send_event.bind(EVENT_WALKING_JOYSTICK))
			
	set_collision_layer_value(Ball.LAYER_PC, true)
	set_collision_mask_value(Ball.LAYER_PC_WALL, true)
	_set_shader_parameter(UTILITIES.SHADER_OUTLINE_COLOR, UTILITIES.COLOR_BORDER_BOUNCY)
	_set_shader_parameter(UTILITIES.SHADER_MODULATE_COLOR, UTILITIES.COLOR_PLAYER) 

func _process(delta: float) -> void:
	super._process(delta)
	animated_sprite_feet.set_velocity(linear_velocity)

func _set_trap_mode(mode: Trap.TrapModes) -> void:
	super._set_trap_mode(mode)
	if is_trapped():
		_send_event(EVENT_CAPTURED)

func _get_usable_power() -> float:
	var out : float 
	if state_aiming_mouse.active:
		out = (global_mouse_start - global_mouse_end).length() 
		if out < BALL_RADIUS:
			return 0.0
		out -= BALL_RADIUS
		out *= 12
	elif state_aiming_joystick.active:
		if action_joystick_aim.is_triggered():
			out = action_joystick_aim.value_axis_2d.length() * MAX_POWER
	## short doesn't count
	return clampf(out, MIN_POWER, MAX_POWER)

func _get_power_ratio() -> float: return (_get_usable_power()-MIN_POWER) / (MAX_POWER - MIN_POWER)

func get_shot_angle_vector() -> Vector2:
	if state_aiming_mouse.active:
		if global_mouse_start != DEFAULT_POS and global_mouse_end != DEFAULT_POS:
			return global_mouse_start - global_mouse_end
	elif state_aiming_joystick.active:
		if action_joystick_aim.triggered:
			return action_joystick_aim.value_axis_2d
	return DEFAULT_POS

func request_draw(node: Node2D) -> void:
	if get_tree().paused:
		return
	if state_aiming.active: 
		_draw_power_indicator(node) 
		if state_aiming_mouse.active:
			_draw_mouse_aim(node)
		elif state_aiming_joystick.active:
			_draw_joystick_aim(node)	

#func _draw() -> void:
	#if get_tree().paused:
		#return
	#if state_aiming.active: 
		#_draw_power_indicator(self) 
		#if state_aiming_mouse.active:
			#_draw_mouse_aim(self)
		#elif state_aiming_joystick.active:
			#_draw_joystick_aim(self)

func _draw_power_indicator(node: Node2D) -> void:
	var visable_power := _get_power_ratio()
	if is_equal_approx(visable_power, 0.0):
		return
	visable_power *= sin(_get_power_ratio())
	visable_power =  (BALL_RADIUS*1.5) + (visable_power  * BALL_RADIUS*8)
	var direction = get_shot_angle_vector()
	if direction == DEFAULT_POS:
		return
	direction = direction.normalized()
	var color_power = Color.from_hsv( (1.0-_get_power_ratio()) *.33, 1.0, 1.0, .5)
	var points = [
		direction*visable_power, # direction.rotated(- PI*.5)*BALL_RADIUS, direction.rotated( PI*.5)*BALL_RADIUS,
		]
	var test_points = points.duplicate()
	var slice_count := 5
	for i in range(slice_count):
		test_points.insert(-1,BALL_RADIUS* direction.rotated( PI * (i / float(10)) ) )
		if i != 0:
			i *= -1
			test_points.insert(0, BALL_RADIUS* direction.rotated( PI * (i / float(10)) ) )
			if Geometry2D.triangulate_polygon(test_points):
				points = test_points.duplicate()
	node.draw_polygon( 	points, [color_power]) 

func _draw_joystick_aim(node: Node2D) -> void:
	var primary_center := to_local( Vector2.ONE * BALL_RADIUS * 2.0)  #  to_local(_screen_center)
	node.draw_circle(primary_center, BALL_RADIUS, COLOR_OTHER, false, 5)
	
	if !action_joystick_aim.is_triggered():
		return
	var direction = get_shot_angle_vector()
	if direction == DEFAULT_POS:
		return
	node.draw_circle(primary_center + direction * _get_power_ratio() * BALL_RADIUS * 1.25, BALL_RADIUS * .75, COLOR_OTHER, true)

func _draw_mouse_aim(node: Node2D) -> void:
	var local_start : Vector2 = to_local(global_mouse_start)
	node.draw_circle(local_start, BALL_RADIUS, COLOR_OTHER, false, 5)
	var direction = get_shot_angle_vector()
	if direction == DEFAULT_POS:
		return
	direction = direction.normalized()
	## Mouse line
	node.draw_line(local_start - direction*BALL_RADIUS, 
		to_local(global_mouse_end), 
		COLOR_OTHER, 2)

func _send_event(event: String) -> void:
	drawing_node.queue_redraw()
	#print(event)
	if state_chart:
		state_chart.send_event(event)
	else:
		push_error(self, " has no State Chart")

func remote_fling(direction_deg: int, power_mod : float) -> void:
	_remote_direction_deg = direction_deg
	_remote_power_mod = power_mod
	_send_event(Ball_Player.EVENT_REMOTE_FLING)

func _on_walk_mode_state_entered() -> void: 
	set_mass(MASS_WALKING)
	set_linear_damp(DAMP_WALKING)

func _on_walk_mode_state_processing(_delta: float) -> void:
	if state_walk.active:
		# spliting the wasd and joystick walks allows for joystick sensitivity  
		var direction := DEFAULT_POS
		if action_walking_wasd.is_triggered():
			direction = action_walking_wasd.value_axis_2d.normalized()
		elif action_walking_controler.is_triggered():
			direction = action_walking_controler.value_axis_2d
		if direction != DEFAULT_POS:
			apply_central_impulse(direction * get_mass() * 10.0)
			return
		_send_event(EVENT_NOT_WALKING)

func _on_roll_mode_state_entered() -> void: 
	animated_sprite_feet.hide()
	set_mass(MASS_ROLLING)
	set_linear_damp(DAMP_ROLLING)

func _on_roll_mode_state_exited() -> void: animated_sprite_feet.show()

func _on_waiting_roll_state_entered() -> void:
	global_mouse_end = DEFAULT_POS
	global_mouse_start = DEFAULT_POS
	drawing_node.queue_redraw()

func _on_waiting_roll_state_processing(delta: float) -> void:
	remaining_roll_cooldown -= delta
	state_chart.set_expression_property(KEY_ROLL_COOLDOWN, remaining_roll_cooldown)

func _on_aiming_state_processing(_delta: float) -> void: drawing_node.queue_redraw()

func _on_mouse_aiming_state_entered() -> void: 
	global_mouse_start = get_global_mouse_position()
	mouse_pressed.activate()

func _on_mouse_aiming_state_processing(_delta: float) -> void: global_mouse_end = get_global_mouse_position()

func _on_mouse_aiming_state_exited() -> void: mouse_unpressed.activate()

func _on_joystick_aiming_state_processing(_delta: float) -> void:
	if !action_joystick_aim.is_triggered():
		_send_event(EVENT_CANCLE_JOYSTICK_AIM)

func _on_try_roll_state_entered() -> void: 
	var _power = _get_usable_power()
	_send_event(EVENT_SHOOT_COMPLETE) # so far no conflict with calling this before applying the impulse
	if is_equal_approx(_power, 0.0):
		return
	remaining_roll_cooldown = DEFAULT_ROLL_COOLDONW
	state_chart.set_expression_property(KEY_ROLL_COOLDOWN, remaining_roll_cooldown)
	apply_central_impulse(get_shot_angle_vector().normalized() * _power)

func _on_remote_fling_state_entered() -> void: _on_roll_mode_state_entered()

func _on_tree_exiting() -> void:
	mouse_unpressed.activate()
	if _instance == self:
		_instance = null

func _on_ready_state_entered() -> void: set_use_custom_integrator(false)

func _on_do_fling_state_entered() -> void:
	var _power := MAX_POWER * _remote_power_mod
	var _direction := Vector2.from_angle(deg_to_rad(_remote_direction_deg))
	_send_event(EVENT_FLING_COMPLETE) # so far no conflict with calling this before applying the impulse
	remaining_roll_cooldown = DEFAULT_ROLL_COOLDONW
	state_chart.set_expression_property(KEY_ROLL_COOLDOWN, remaining_roll_cooldown)
	apply_central_impulse(_direction * _power)
