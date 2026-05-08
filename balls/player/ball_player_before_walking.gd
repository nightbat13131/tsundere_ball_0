class_name Ball_Player_BeforeWalking extends Ball
# https://www.youtube.com/watch?v=tgrDkFdEK0I
## there was a problem with Ball_Player going odd directions if shot while moving, but turning off rotation seems to have solved this problem.

## if I insit on a walking mode, doing "Freeze Mode Kinimatic" might help

const DEFAULT_POS := Vector2.INF
#const COLOR_POWER = Color(Color.RED, .75)
const COLOR_OTHER = Color(Color.GRAY, .50)

const CANCLE_PAUSE_DURATION := .5
const MAX_POWER := 1600.0
const MIN_POWER := MAX_POWER * .05

enum ControlerType {NONE, BALL_POINTER, ANY_DRAG_LOCAL, LongDistance, ANY_DRAG_GLOBAL, ANY_DRAG_GLOBAL_CYCLE}

var cancle_pause := 0.0
var cycle_mod := 1

static var _instance : Ball_Player_BeforeWalking

@export var control_type := ControlerType.BALL_POINTER: 
	set(value):
		control_type = value
		if npc_finder:
			npc_finder.visible = control_type in [ControlerType.LongDistance]
			cancle_pause = CANCLE_PAUSE_DURATION

@export_category("G.U.I.D.E.")
@export var pc_controler_context: GUIDEMappingContext
@export var action_cancle_ball: GUIDEAction
@export var action_mouse_pressed : GUIDEAction
@export var action_mouse_release : GUIDEAction

@onready var npc_finder: RayCast2D = %NPC_Finder

var _power := MIN_POWER :
	set(value):
		_power = value
		if _power > MAX_POWER and cycle_mod == 1:
			cycle_mod = -1
		elif _power < MIN_POWER and cycle_mod == -1:
			cycle_mod = 1

var mouse_start := DEFAULT_POS
var mouse_end := DEFAULT_POS

func _ready() -> void:
	super._ready()
	_instance = self
	tree_exiting.connect(_on_tree_exiting)
	UTILITIES.apply_z_layer(self, UTILITIES.Z_Indexes.BALL_PLAYER)
	
	control_type = control_type
	if pc_controler_context:
		GUIDE.enable_mapping_context(pc_controler_context)
		if action_mouse_pressed == null:
			push_error("no action_mouse_pressed")
		if action_mouse_release == null:
			push_error("no action_mouse_release")
		if action_cancle_ball == null:
			push_error("no action_cancle_ball")
	set_collision_layer_value(Ball.LAYER_PC, true)
	set_collision_mask_value(Ball.LAYER_PC_WALL, true)
	npc_finder.set_collision_mask_value(Ball.LAYER_NPC, true)
	_set_shader_parameter(UTILITIES.SHADER_OUTLINE_COLOR, UTILITIES.COLOR_BORDER_BOUNCY)
	_set_shader_parameter(UTILITIES.SHADER_MODULATE_COLOR, UTILITIES.COLOR_PLAYER) 

func _get_usable_power() -> float:
	var out : float 
	if control_type in [ControlerType.BALL_POINTER, ControlerType.ANY_DRAG_GLOBAL_CYCLE]: 
		out = _power
	elif control_type in [ControlerType.ANY_DRAG_GLOBAL, ControlerType.ANY_DRAG_LOCAL]: 
		out = (mouse_start - mouse_end).length() * 12
	elif control_type == ControlerType.LongDistance:
		if npc_finder.is_colliding():
			out = npc_finder.get_collision_point().length() * 5
	return clampf(out, MIN_POWER, MAX_POWER)

func _get_power_ratio() -> float: 
	#prints(_power, _get_usable_power(),  MAX_POWER, _get_usable_power() / MAX_POWER)
	return _get_usable_power() / MAX_POWER

func _process(delta: float) -> void:
	super._process(delta)
	if action_cancle_ball.is_triggered():
		_cancle_shoot()
		return
	if cancle_pause > 0.0:
		cancle_pause -= delta
		return
	match control_type:
		ControlerType.NONE:
			return
		ControlerType.BALL_POINTER:
			_ball_pointer(delta)
		ControlerType.ANY_DRAG_LOCAL:
			_any_drag_0(delta)
		ControlerType.LongDistance:
			_longdistance_0(delta)
		ControlerType.ANY_DRAG_GLOBAL:
			_any_drag_1(delta)
		ControlerType.ANY_DRAG_GLOBAL_CYCLE:
			_any_drag_2(delta)

func _any_drag_2(delta: float) -> void:
	queue_redraw()
	if Input.is_action_pressed("left_click"):
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouse_end = get_global_mouse_position()
		_power += delta * cycle_mod * 1000
		if mouse_start == DEFAULT_POS:
			mouse_start = mouse_end
	else:
		if mouse_start != DEFAULT_POS and mouse_end != DEFAULT_POS:
			_shoot_0(mouse_start - mouse_end)

func _any_drag_1(_delta) -> void:
	queue_redraw()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouse_end = get_global_mouse_position()
		if mouse_start == DEFAULT_POS:
			mouse_start = mouse_end
	else:
		if mouse_start != DEFAULT_POS and mouse_end != DEFAULT_POS:
			_shoot_0(mouse_start - mouse_end)

func _any_drag_0(_delta) -> void:
	queue_redraw()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouse_end = get_local_mouse_position()
		if mouse_start == DEFAULT_POS:
			mouse_start = mouse_end
	else:
		if mouse_start != DEFAULT_POS and mouse_end != DEFAULT_POS:
			_power = mouse_start.distance_to(mouse_end)*10
			_shoot_0(mouse_start - mouse_end)
			mouse_start = DEFAULT_POS
			mouse_end = DEFAULT_POS

func _longdistance_0(_delta) -> void:
	#power is related to the distance to the target ball - father stronger 
	queue_redraw()
	# not using GUIDE for mouse location because local was not working how I wanted
	npc_finder.set_rotation(get_local_mouse_position().angle())
	if action_mouse_release.is_triggered():
		_shoot_0(Vector2.from_angle(npc_finder.rotation))

func _ball_pointer(delta: float) -> void:
	queue_redraw()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_power += delta *1000
		mouse_end = get_local_mouse_position()
	else:
		if _power > MIN_POWER + .01:
			_shoot_0(mouse_end*-1)
			mouse_end = DEFAULT_POS

func _shoot_0(direction: Vector2) -> void:
	apply_central_impulse(direction.normalized() * _get_usable_power())
	_power = MIN_POWER
	mouse_start = DEFAULT_POS
	mouse_end = DEFAULT_POS

func _cancle_shoot() -> void:
	_power = 0.0
	mouse_end = DEFAULT_POS
	mouse_start = DEFAULT_POS
	cancle_pause = CANCLE_PAUSE_DURATION
	queue_redraw()

func _draw() -> void:
	if cancle_pause > 0.0:
		return
	var visable_power = _get_usable_power()  * sin(_get_power_ratio()) * .1
	if visable_power == NAN:
		return
	if visable_power > .1:
		visable_power = max(30, visable_power)
	var color_power = Color.from_hsv( (1.0-_get_power_ratio()) *.33, 1.0, 1.0, .5)

	match control_type:
		ControlerType.NONE:
			return
		ControlerType.BALL_POINTER: 
			if is_equal_approx(_power, 0.0):
				return
			var angle = (mouse_end*-1).angle()
			draw_line(Vector2.ZERO, mouse_end, COLOR_OTHER, 2 )
			draw_polygon(
				[ Vector2.from_angle(angle) * visable_power, Vector2.from_angle(angle - (PI*.5)) * visable_power * .5, Vector2.from_angle(angle + (PI*.5)) * visable_power * .5 ]
				, [color_power])
		ControlerType.ANY_DRAG_LOCAL:
			if mouse_start != DEFAULT_POS and mouse_end != DEFAULT_POS:
				var angle = (mouse_start - mouse_end).angle()
				draw_line(mouse_start, mouse_end, COLOR_OTHER, 2 )
				draw_line(Vector2.ZERO, Vector2.from_angle(angle)*visable_power, color_power, 2)
		ControlerType.LongDistance:
			var angle = npc_finder.rotation
			draw_polygon(
				[ Vector2.from_angle(angle) * visable_power, Vector2.from_angle(angle - (PI*.5)) * visable_power * .5, Vector2.from_angle(angle + (PI*.5)) * visable_power * .5 ]
				, [color_power])
		ControlerType.ANY_DRAG_GLOBAL:
			var angle = (mouse_start - mouse_end).angle()
			draw_line(to_local(mouse_start), to_local(mouse_end), COLOR_OTHER, 2) # mouse line
			draw_polygon(
				[Vector2.from_angle(angle)*visable_power, Vector2.from_angle(angle - PI*.5)*BALL_RADIUS, Vector2.from_angle(angle + PI*.5)*BALL_RADIUS,  ], [color_power]
			)
		ControlerType.ANY_DRAG_GLOBAL_CYCLE :
			var angle = (mouse_start - mouse_end).angle()
			draw_line(to_local(mouse_start), to_local(mouse_end), COLOR_OTHER, 2 )
			draw_line(Vector2.ZERO, Vector2.from_angle(angle)*visable_power, color_power, 2)

func _on_tree_exiting() -> void:
	if _instance == self:
		_instance = null

static func set_control_type(controler_type: ControlerType) -> void:
	if _instance:
		_instance.control_type = controler_type
		
