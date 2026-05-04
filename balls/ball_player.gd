class_name Ball_Player extends Ball
# https://www.youtube.com/watch?v=tgrDkFdEK0I
## there was a problem with Ball_Player going odd directions if shot while moving, but jumping the angular_damping to 50 (from 1) seemed to clean it up. 

const DEFAULT_POS := Vector2.INF

enum ContolerType {NONE, BALL_POINTER, ANY_DRAG_0, FINDER}

@export var control_type := ContolerType.BALL_POINTER
@export var pc_controler_context: GUIDEMappingContext

@onready var npc_finder: RayCast2D = %NPC_Finder

var power := 0.0
var mouse_start := DEFAULT_POS
var mouse_end := DEFAULT_POS

func _ready() -> void:
	super._ready()
	if pc_controler_context:
		GUIDE.enable_mapping_context(pc_controler_context)
	set_collision_layer_value(Ball.LAYER_PC, true)
	set_collision_mask_value(Ball.LAYER_PC_WALL, true)
	
	npc_finder.set_collision_mask_value(Ball.LAYER_NPC, true)

func _process(delta: float) -> void:
	super._process(delta)
	match control_type:
		ContolerType.NONE:
			return
		ContolerType.BALL_POINTER:
			_ball_pointer(delta)
		ContolerType.ANY_DRAG_0:
			_any_drag_0(delta)

func _any_drag_0(delta) -> void:
	queue_redraw()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouse_end = get_local_mouse_position()
		if mouse_start == DEFAULT_POS:
			mouse_start = mouse_end
			#rotation = 0.0
	else:
		if mouse_start != DEFAULT_POS and mouse_end != DEFAULT_POS:
			power = mouse_start.distance_to(mouse_end)*10
			_shoot_0(mouse_start - mouse_end)
			mouse_start = DEFAULT_POS
			mouse_end = DEFAULT_POS

func _ball_pointer(delta: float) -> void:
	queue_redraw()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		power += delta *1000
		mouse_end = get_local_mouse_position()
	else:
		if power > 0.0:
			_shoot_0(mouse_end*-1)
			mouse_end = DEFAULT_POS

func _shoot_0(direction: Vector2) -> void:
	#set_angular_velocity(0)
	
	apply_central_impulse(direction.normalized() * power)
	power = 0.0

func _draw() -> void:
	var visable_power = power*.2
	match control_type:
		ContolerType.BALL_POINTER: 
			var angle = (mouse_end*-1).angle()
			draw_line(Vector2.ZERO, mouse_end, Color.AQUAMARINE, 2 )
			draw_polygon(
				[ Vector2.from_angle(angle) * visable_power, Vector2.from_angle(angle - (PI*.5)) * visable_power * .5, Vector2.from_angle(angle + (PI*.5)) * visable_power * .5 ]
				, [Color.RED])
			#draw_line(Vector2.ZERO, Vector2.from_angle((get_local_mouse_position()*-1).angle()) *40,Color.RED, )
		ContolerType.ANY_DRAG_0:
			if mouse_start != DEFAULT_POS and mouse_end != DEFAULT_POS:
				draw_line(mouse_start, mouse_end, Color.GREEN, 2 )
				draw_line(Vector2.ZERO, mouse_start - mouse_end, Color.ORANGE, 2)
		ContolerType.FINDER:
			var angle = (mouse_end*-1).angle()
			draw_polygon(
				[ Vector2.from_angle(angle) * visable_power, Vector2.from_angle(angle - (PI*.5)) * visable_power * .5, Vector2.from_angle(angle + (PI*.5)) * visable_power * .5 ]
				, [Color.RED])
