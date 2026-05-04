class_name Ball extends RigidBody2D

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

var fastest : float = 0
var _is_trapped := false

func _ready() -> void:
	set_collision_layer_value(LAYER_BALL, true)
	set_collision_mask_value(LAYER_BALL, true)

func toggle_rolling() -> void: animated_sprite_ball.is_rolling = !animated_sprite_ball.is_rolling

func _process(_delta: float) -> void:
	animated_sprite_ball.set_velocity(linear_velocity)
	animated_sprite_ball.rotation = rotation *- 1
	if linear_velocity.length() > fastest:
		fastest = linear_velocity.length()
		#print(fastest)

func get_captured(trap_mode: Area2D_Enhanced.TrapModes) -> bool:
	if _is_trapped: # first trap takes priority 
		return false
	set_z_index(UTILITIES.Z_Indexes.IN_TRAP as int)
	set_freeze_enabled.call_deferred(true)
	animated_sprite_ball.freeze()
	set_freeze_mode(RigidBody2D.FREEZE_MODE_KINEMATIC)
	match trap_mode:
		Area2D_Enhanced.TrapModes.PILLAR:
			
			pass
		Area2D_Enhanced.TrapModes.HOLE:
			set_modulate(Color.DIM_GRAY)
			collision_shape_2d.set_disabled.call_deferred(true)
			#set_physics_process.call_deferred(false)
			
			pass
			
	return true
