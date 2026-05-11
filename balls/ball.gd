class_name Ball extends RigidBody2D

@export var _npc_type:= NPCType.RED
enum NPCType {RED, YELLOW, BLUE, PLAYER}

@export_category("Sounds")
@export var ball_hit : AudioStream
@export var wall_hit : AudioStream
@export var door_hit : AudioStream

const DEFAULT_POS := Vector2.INF

const BALL_RADIUS = 16.0

const LAYER_BALL = 32
const LAYER_NPC = 1
const LAYER_NPC_WALL = 11
const LAYER_PC = 2
const LAYER_PC_WALL = 12
const LAYER_NPC_RED = 3
const LAYER_NPC_YELLOW = 4
const LAYER_NPC_BLUE = 5

@onready var animated_sprite_ball: AnimatedSprite_Ball = %AnimatedSprite_Ball
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = %VisibleOnScreenNotifier2D

var _inital_pos : Vector2 = DEFAULT_POS
var _needs_pos_reset := false

var _trap_mode := Trap.TrapModes.NONE: set = _set_trap_mode

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	visible_on_screen_notifier_2d.screen_exited.connect(_on_screen_exited)
	set_collision_layer_value(LAYER_BALL, true)
	set_collision_mask_value(LAYER_BALL, true)
	
	## needed for _on_body_entered to report collisions
	set_contact_monitor(true)
	set_max_contacts_reported(5)
	body_entered.connect(_on_body_entered)
	##

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	animated_sprite_ball.set_velocity(linear_velocity)
	animated_sprite_ball.rotation = rotation *- 1

func _set_shader_parameter(param: StringName, value: Variant) -> void:
	#print(get_material_override().get_shader_parameter(param))
	animated_sprite_ball.set_instance_shader_parameter(param, value)

func _set_trap_mode(mode: Trap.TrapModes) -> void:
	if _trap_mode == mode:
		return # no change
	_trap_mode = mode

func is_trapped() -> bool: return _trap_mode != Trap.TrapModes.NONE

func get_captured(trap_mode: Trap.TrapModes) -> bool:
	if is_trapped(): # first trap takes priority 
		return false
	_set_trap_mode(trap_mode)
	
	set_z_index(UTILITIES.Z_Indexes.IN_TRAP as int)
	
	set_freeze_enabled.call_deferred(true)
	animated_sprite_ball.freeze()
	set_freeze_mode(RigidBody2D.FREEZE_MODE_KINEMATIC)
	match trap_mode:
		Trap.TrapModes.PILLAR:
			_set_shader_parameter(UTILITIES.SHADER_OUTLINE_COLOR, UTILITIES.COLOR_BORDER_OBSTICAL)
		Trap.TrapModes.HOLE:
			_set_shader_parameter(UTILITIES.SHADER_MODULATE_COLOR, get_color(_npc_type).darkened(UTILITIES.DARKEN_HOLE))
			_set_shader_parameter(UTILITIES.SHADER_OUTLINE_COLOR, UTILITIES.COLOR_BORDER_NON_ENTITIY)
			collision_shape_2d.set_disabled.call_deferred(true)
			pass
	return true

static func get_color(npc_type: NPCType) -> Color:
	match npc_type:
		NPCType.RED:
			return UTILITIES.COLOR_NPC_RED
		NPCType.YELLOW:
			return UTILITIES.COLOR_NPC_YELLOW
		NPCType.BLUE:
			return UTILITIES.COLOR_NPC_BLUE
	return UTILITIES.COLOR_PLAYER

func _on_body_entered(body: Node) -> void:
	if body is Breakable: # has it's own sound to play
		if get_mass() > Ball_Player.MASS_WALKING:  # precent player in walk mode from triggering the break
			body.remote_hit(self)
	elif body is Ball:
		if ball_hit:
			SoundManager.request_sfx(ball_hit)
	elif body is Door:
		if door_hit: 
			SoundManager.request_sfx(door_hit)
	else:
		SoundManager.request_sfx(wall_hit)

func _on_screen_exited() -> void:
	if _trap_mode != Trap.TrapModes.NONE:
		return
	_needs_pos_reset = true
	set_use_custom_integrator(true)

func _send_event(_event: String) -> void: pass

# https://forum.godotengine.org/t/what-is-the-proper-way-to-teleport-rigidbody2d/27752/3
func _integrate_forces(physics_state: PhysicsDirectBodyState2D) -> void:
	if _inital_pos == DEFAULT_POS:
		_inital_pos = physics_state.transform.origin
	if _needs_pos_reset: 
		var new_transform = physics_state.get_transform()
		new_transform.origin = _inital_pos #to_global(_inital_pos)
		physics_state.set_transform(new_transform)
		# Reset velocities to avoid the object going through walls
		physics_state.set_linear_velocity(Vector2.ZERO)
		physics_state.set_angular_velocity(0.0)
		_send_event(Ball_Player.EVENT_TELEPORTED)
		_needs_pos_reset = false
