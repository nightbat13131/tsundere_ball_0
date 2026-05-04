class_name Ball_Player extends Ball
# https://www.youtube.com/watch?v=tgrDkFdEK0I
## there was a problem with Ball_Player going odd directions if shot while moving, but turning off rotation seems to have solved this problem.

## if I insit on a walking mode, doing "Freeze Mode Kinimatic" might help

const DEFAULT_POS := Vector2.INF
const COLOR_POWER = Color(Color.RED, .75)
const COLOR_OTHER = Color(Color.AQUA, .75)

const CANCLE_PAUSE_DURATION := .5

enum ContolerType {NONE, BALL_POINTER, ANY_DRAG_0, LongDistance}


var cancle_pause := 0.0

@export var control_type := ContolerType.BALL_POINTER: 
	set(value):
		control_type = value
		if npc_finder:
			npc_finder.visible = control_type in [ContolerType.LongDistance]
			
@export_category("G.U.I.D.E.")
@export var pc_controler_context: GUIDEMappingContext
@export var action_cancle_ball: GUIDEAction
@export var action_mouse_location : GUIDEAction
@export var action_mouse_pressed : GUIDEAction
@export var action_mouse_release : GUIDEAction

@onready var npc_finder: RayCast2D = %NPC_Finder

var _power := 0.0 : get = _get_power
var mouse_start := DEFAULT_POS
var mouse_end := DEFAULT_POS

func _ready() -> void:
	super._ready()
	set_z_index(UTILITIES.Z_Indexes.BALL_PLAYER as int)
	control_type = control_type
	if pc_controler_context:
		GUIDE.enable_mapping_context(pc_controler_context)
		if action_mouse_location == null:
			push_error("No mouse_location action ")
		if action_mouse_pressed == null:
			push_error("no action_mouse_pressed")
		if action_mouse_release == null:
			push_error("no action_mouse_release")
		if action_cancle_ball == null:
			push_error("no action_cancle_ball")
	set_collision_layer_value(Ball.LAYER_PC, true)
	set_collision_mask_value(Ball.LAYER_PC_WALL, true)
	npc_finder.set_collision_mask_value(Ball.LAYER_NPC, true)

func _get_power() -> float:
	if control_type in [ContolerType.BALL_POINTER, ContolerType.ANY_DRAG_0]: 
		return _power
	elif control_type == ContolerType.LongDistance:
		if npc_finder.is_colliding():
			return npc_finder.get_collision_point().length() * 5
	return 50.0

func _process(delta: float) -> void:
	super._process(delta)
	if action_cancle_ball.is_triggered():
		_cancle_shoot()
	if cancle_pause > 0.0:
		cancle_pause -= delta
		return
	match control_type:
		ContolerType.NONE:
			return
		ContolerType.BALL_POINTER:
			_ball_pointer(delta)
		ContolerType.ANY_DRAG_0:
			_any_drag_0(delta)
		ContolerType.LongDistance:
			_longdistance_0(delta)

func _any_drag_0(_delta) -> void:
	queue_redraw()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouse_end = get_local_mouse_position()
		if mouse_start == DEFAULT_POS:
			mouse_start = mouse_end
			#rotation = 0.0
	else:
		if mouse_start != DEFAULT_POS and mouse_end != DEFAULT_POS:
			_power = mouse_start.distance_to(mouse_end)*10
			_shoot_0(mouse_start - mouse_end)
			mouse_start = DEFAULT_POS
			mouse_end = DEFAULT_POS

func _longdistance_0(_delta) -> void:
	queue_redraw()
	#power is related to the distance to the target ball - father stronger 
	npc_finder.set_rotation(to_local(action_mouse_location.value_axis_2d).angle())
	if action_mouse_release.is_triggered():
		_shoot_0(Vector2.from_angle(npc_finder.rotation))
	#prints(action_mouse_location.value_axis_2d, to_local(action_mouse_location.value_axis_2d), action_mouse_pressed.triggered, action_mouse_pressed.triggered_seconds, action_mouse_release.triggered, action_mouse_release.triggered_seconds )
	pass

func _ball_pointer(delta: float) -> void:
	queue_redraw()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_power += delta *1000
		mouse_end = get_local_mouse_position()
	else:
		if _get_power() > 0.0:
			_shoot_0(mouse_end*-1)
			mouse_end = DEFAULT_POS

func _shoot_0(direction: Vector2) -> void:
	#set_angular_velocity(0)
	apply_central_impulse(direction.normalized() * _get_power())
	_power = 0.0

func _cancle_shoot() -> void:
	_power = 0.0
	mouse_end = DEFAULT_POS
	mouse_start = DEFAULT_POS
	cancle_pause = CANCLE_PAUSE_DURATION
	queue_redraw()
	pass

func _draw() -> void:
	var visable_power = _get_power()  *.2
	if visable_power > .1:
		visable_power = max(30, visable_power)
		
	match control_type:
		ContolerType.NONE:
			return
		ContolerType.BALL_POINTER: 
			var angle = (mouse_end*-1).angle()
			draw_line(Vector2.ZERO, mouse_end, COLOR_OTHER, 2 )
			draw_polygon(
				[ Vector2.from_angle(angle) * visable_power, Vector2.from_angle(angle - (PI*.5)) * visable_power * .5, Vector2.from_angle(angle + (PI*.5)) * visable_power * .5 ]
				, [COLOR_POWER])
			#draw_line(Vector2.ZERO, Vector2.from_angle((get_local_mouse_position()*-1).angle()) *40,Color.RED, )
		ContolerType.ANY_DRAG_0:
			if mouse_start != DEFAULT_POS and mouse_end != DEFAULT_POS:
				draw_line(mouse_start, mouse_end, COLOR_OTHER, 2 )
				draw_line(Vector2.ZERO, mouse_start - mouse_end, COLOR_POWER, 2)
		ContolerType.LongDistance:
			var angle = npc_finder.rotation
			draw_polygon(
				[ Vector2.from_angle(angle) * visable_power, Vector2.from_angle(angle - (PI*.5)) * visable_power * .5, Vector2.from_angle(angle + (PI*.5)) * visable_power * .5 ]
				, [COLOR_POWER])
