@tool
class_name Trap extends Area2D_Enhanced


signal used(ball: Ball)
signal complete(ball: Ball)

const RADIUS = 30.0
const SIDE_LENGTH = 50 # 53.178943201233324
const THICKNESS = 4.0

const FRAME_INACITVE = 0
const FRAME_ACITVE = 1

## Pillar: Captures ball and holds it IN the way
## Hole: Captures's ball and moves it OUT of the way.
## Release the ball when the release trigger happens. 
enum TrapModes {PILLAR, HOLE, CLAW_HOLE, CLAW_PILLAR, NONE}

var _used := false # prevent triggering multiple times in the same frame

@export var dependency : Area2D_Enhanced:
	set(value):
		dependency = value
		queue_redraw()

#@export var release_trigger : Area2D_Enhanced

@export_category("Icons")
@export var _red_icons: CompressedTexture2D
@export var _yellow_icons: CompressedTexture2D
@export var _blue_icons: CompressedTexture2D
@export var _player_icons : CompressedTexture2D

@export var _trap_mode := TrapModes.HOLE

@onready var collision_shape: CollisionShape2D = %CollisionShape
@onready var sprite_2d: Sprite2D = %Sprite2D

var is_locked := false

func _ready() -> void:
	super._ready()
	UTILITIES.apply_z_layer(self, UTILITIES.Z_Indexes.TRAPS)
	if dependency:
		_hybernate()
		dependency.used.connect(_on_unlock)
		is_locked = true
	if is_locked:
		sprite_2d.set_frame(FRAME_INACITVE)
	else:
		sprite_2d.set_frame(FRAME_ACITVE)
	var shape: Shape2D
	match _trap_mode:
		TrapModes.HOLE:
			shape = CircleShape2D.new()
			shape.radius = RADIUS
			collision_shape.set_shape(shape)
		TrapModes.PILLAR:
			shape = RectangleShape2D.new()
			shape.size = Vector2.ONE * SIDE_LENGTH
			collision_shape.set_shape(shape)
	match npc_type:
		Ball.NPCType.RED:
			sprite_2d.set_texture(_red_icons)
		Ball.NPCType.BLUE:
			sprite_2d.set_texture(_blue_icons)
		Ball.NPCType.YELLOW:
			sprite_2d.set_texture(_yellow_icons)
		Ball.NPCType.PLAYER:
			sprite_2d.set_texture(_player_icons)

func _hybernate() -> void:
	if Engine.is_editor_hint():
		return
	set_process_mode.call_deferred(Node.PROCESS_MODE_DISABLED)
	queue_redraw()

func _on_unlock(_ball: Ball)-> void: 
	is_locked = false
	set_process_mode.call_deferred(Node.PROCESS_MODE_INHERIT)
	queue_redraw()
	sprite_2d.set_frame(FRAME_ACITVE)

func _on_body_entered(body: Node2D) -> void:
	if _used:
		return
	if !body is Ball:
		push_warning("Trap ", self, "triggered for a ", body, " instead of a ball.")
		return
	_used = body.get_captured(_trap_mode)
	if !_used: # trapping for this body failed
		return
	used.emit(body)
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
	tween_pos.tween_callback(complete.emit.bind(body))

func _process(_delta: float) -> void: queue_redraw()

func _draw() -> void:
	var color = Ball_NPC.get_color(npc_type)
	
	var row_count := 3
	var row_thickness : float
	var row_mod := (1.0 - fmod(Time.get_unix_time_from_system(), 1.0))
	
	if Engine.is_editor_hint() and dependency:
		draw_line(Vector2.ZERO, to_local(dependency.position), Color.GRAY, THICKNESS)
	
	match _trap_mode:
		TrapModes.HOLE:
			row_thickness = RADIUS / float(row_count)
			draw_circle(Vector2.ZERO, RADIUS, color, false, THICKNESS)
			
			if is_locked:
				draw_circle(Vector2.ZERO, RADIUS + THICKNESS*.5, UTILITIES.LOCKED_COLOR, false, THICKNESS)
			else: 
				color = color.darkened(.20)
				for row_num : int in range(row_count): 
					draw_circle(Vector2.ZERO, (row_thickness * row_num) + (row_thickness * row_mod) , color, false, THICKNESS*.5)
					
					
		TrapModes.PILLAR:
			var half_length = SIDE_LENGTH*.5
			row_thickness = half_length / float(row_count)
			draw_polyline( UTILITIES.get_square_points(half_length), color, THICKNESS)
			if is_locked:
				draw_polyline( UTILITIES.get_square_points(half_length + THICKNESS*.5), UTILITIES.LOCKED_COLOR, THICKNESS)
			else:
				color = color.darkened(.20)
				for row_num : int in range(row_count): 
					draw_polyline( UTILITIES.get_square_points((row_thickness * row_num) + (row_thickness * row_mod)), color, THICKNESS*.5)
