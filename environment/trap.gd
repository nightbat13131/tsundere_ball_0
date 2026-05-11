@tool
class_name Trap extends Area2D_Enhanced

signal used(ball: Ball, trap: Trap)
signal complete(ball: Ball, trap: Trap)

const RADIUS = 30.0
const SIDE_LENGTH = 50 # 53.178943201233324
const THICKNESS = 4.0

const FRAME_INACITVE = 0
const FRAME_ACITVE = 1

## Pillar: Captures ball and holds it IN the way
## Hole: Captures's ball and moves it OUT of the way.
## Simple Trigger: something happens, but the ball is not "caught"
## Release the ball when the release trigger happens. 
enum TrapModes {PILLAR, HOLE, SIMPLE_TRIGGER, CLAW_HOLE, CLAW_PILLAR, NONE}

var _used := false: get = is_used # prevent triggering multiple times in the same frame
var _shape: Shape2D


@export var _dependency_condition := UTILITIES.Conditions.AND
@export var dependencys : Array[Area2D_Enhanced] = []
var _dependencys : Array[Area2D_Enhanced] = []

@export var _disabler_condition := UTILITIES.Conditions.OR
@export var disablers : Array[Area2D_Enhanced] = []
var _disablers : Array[Area2D_Enhanced] = []

#@export var release_trigger : Area2D_Enhanced
@export var _trap_mode := TrapModes.HOLE
@export_category("Icons")
@export var _red_icons: CompressedTexture2D
@export var _yellow_icons: CompressedTexture2D
@export var _blue_icons: CompressedTexture2D
@export var _player_icons : CompressedTexture2D



@onready var collision_shape: CollisionShape2D = %CollisionShape
@onready var sprite_2d: Sprite2D = %Sprite2D

var is_locked := false

func _ready() -> void:
	super._ready()
	UTILITIES.apply_z_layer(self, UTILITIES.Z_Indexes.TRAPS)
	set_modulate(Color(Color.WHITE, .75))
	_setup_icon()
	_setup_collision_shape()
	if Engine.is_editor_hint():
		return
	_connect_interactions()

func _connect_interactions() -> void:
	for each_dp in dependencys:
		if each_dp:
			_dependencys.append(each_dp)
			each_dp.used.connect(_on_unlock_check)
			_hybernate()
	for each_ds in disablers:
		if each_ds:
			_disablers.append(each_ds)
			each_ds.used.connect(_disable_check)

func _disable_check(_ball: Ball, trap: Trap) -> void:
	if _disabler_condition == UTILITIES.Conditions.OR:
		_disablers = []
	elif _disabler_condition == UTILITIES.Conditions.AND:
		_disablers.erase(trap)
	if _disablers.is_empty():
		_hybernate()

func _hybernate() -> void:
	if Engine.is_editor_hint():
		return
	collision_shape.set_disabled.call_deferred(true)
	is_locked = true
	#set_process_mode.call_deferred(Node.PROCESS_MODE_DISABLED)
	queue_redraw()

func _on_unlock_check(_ball: Ball, trap: Trap)-> void: 
	if _dependency_condition == UTILITIES.Conditions.OR:
		_dependencys = []
	else:
		_dependencys.erase(trap)
	if _dependencys.size() <= 1:
		_do_unlock()

func _do_unlock() -> void:
	is_locked = false
	collision_shape.set_disabled.call_deferred(false)
	#set_process_mode.call_deferred(Node.PROCESS_MODE_INHERIT)
	queue_redraw()
	sprite_2d.set_frame(FRAME_ACITVE)

func is_used() -> bool: return _used

func _on_body_entered(body: Node2D) -> void:
	if is_used():
		return
	if !body is Ball:
		if !body is TileMapLayer_Enhanced: ## not ideal, but needs no error
			push_warning("Trap ", self, "triggered for a ", body, " instead of a ball.")
		return
	if _trap_mode == TrapModes.SIMPLE_TRIGGER:
		_used = true
		used.emit(body, self)
		_hybernate()
		return
	_used = body.get_captured(_trap_mode)
	if !is_used(): # trapping for this body failed
		return
	used.emit(body, self)
	Portrait.request_emotion(FaceTexture.Emotions.BLUSHING)
	_hybernate()
	#suck to center
	var tween_pos = get_tree().create_tween()
	tween_pos.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween_pos.tween_property(body, "global_position", global_position, 1.0)
	if _trap_mode == TrapModes.HOLE:
		var tween_scale = get_tree().create_tween()
		tween_scale.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween_scale.set_ease(Tween.EASE_IN_OUT)
		tween_scale.set_trans(Tween.TRANS_BOUNCE)
		tween_scale.tween_property(body.animated_sprite_ball, "scale", Vector2(.8, .8), 1.0)
	tween_pos.tween_callback(complete.emit.bind(body, self))

func _process(_delta: float) -> void: queue_redraw()

func _draw_hole(color := Color.WHITE, row_count := 3, row_mod: float = 0.1) -> void:
	var row_thickness : float
	row_thickness = RADIUS / float(row_count)
	for row_num : int in range(row_count): 
		draw_circle(Vector2.ZERO, (row_thickness * row_num) + (row_thickness * row_mod) , color, false, THICKNESS*.5)

func _draw_pillar(color := Color.WHITE, row_count := 3, row_mod: float = 0.1) -> void:
	var row_thickness : float
	row_thickness = (SIDE_LENGTH*.5) / float(row_count)

	for row_num : int in range(row_count): 
		draw_polyline( UTILITIES.get_square_points((row_thickness * row_num) + (row_thickness * row_mod)), color, THICKNESS*.5)

func _draw_trigger(color := Color.WHITE, row_count := 3, row_mod: float = 0.1) -> void:
	row_count *= 2
	var radian_width = TAU / row_count
	var start_radian = radian_width * row_mod

	for i in range(row_count):
		draw_line(Vector2.ZERO, Vector2.from_angle(start_radian + radian_width * i)*Ball.BALL_RADIUS*1.8, color, THICKNESS)

func _draw() -> void:
	if Engine.is_editor_hint():
		_draw_engine()
	var color = Ball_NPC.get_color(npc_type)
	var row_count := 3
	var row_mod := (1.0 - fmod(Time.get_unix_time_from_system(), 1.0))
	
	if _shape is CircleShape2D:
		draw_circle(Vector2.ZERO, RADIUS, color, false, THICKNESS)
		if is_locked:
			draw_circle(Vector2.ZERO, RADIUS + THICKNESS*.5, UTILITIES.LOCKED_COLOR, false, THICKNESS)
	elif _shape is RectangleShape2D:
		draw_polyline( UTILITIES.get_square_points(SIDE_LENGTH * .5), color, THICKNESS)
		if is_locked:
			draw_polyline( UTILITIES.get_square_points((SIDE_LENGTH * .5) + THICKNESS*.5), UTILITIES.LOCKED_COLOR, THICKNESS)
	
	if is_locked:
		color = UTILITIES.LOCKED_COLOR
		row_mod =  0.0
	else:
		color = color.darkened(.20)
	match _trap_mode:
		TrapModes.HOLE:
			_draw_hole(color, row_count, row_mod)
		TrapModes.PILLAR:
			_draw_pillar(color, row_count, row_mod)
		TrapModes.SIMPLE_TRIGGER:
			_draw_trigger(color, row_count, row_mod)

func _draw_engine() -> void:
	for dependency in dependencys:
		if dependency:
			draw_line(Vector2.ONE * 5, to_local(dependency.position), Color.PALE_GREEN, THICKNESS)
		for disabler in disablers:
			if disabler:
				draw_line(Vector2.ONE * -5, to_local(disabler.position), Color.AQUA, THICKNESS)

func _setup_icon() -> void:
	match npc_type:
		Ball.NPCType.RED:
			sprite_2d.set_texture(_red_icons)
		Ball.NPCType.BLUE:
			sprite_2d.set_texture(_blue_icons)
		Ball.NPCType.YELLOW:
			sprite_2d.set_texture(_yellow_icons)
		Ball.NPCType.PLAYER:
			sprite_2d.set_texture(_player_icons)
	if is_locked:
		sprite_2d.set_frame(FRAME_INACITVE)
	else:
		sprite_2d.set_frame(FRAME_ACITVE)
	pass

func _setup_collision_shape() -> void:
	match _trap_mode:
		TrapModes.HOLE:
			_shape = CircleShape2D.new()
			_shape.radius = RADIUS
		TrapModes.SIMPLE_TRIGGER:
			_shape = CircleShape2D.new()
			_shape.radius = RADIUS
		TrapModes.PILLAR:
			_shape = RectangleShape2D.new()
			_shape.size = Vector2.ONE * SIDE_LENGTH
	collision_shape.set_shape(_shape)
