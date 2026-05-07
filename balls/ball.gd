class_name Ball extends RigidBody2D


enum NPCType {RED, YELLOW, BLUE}

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

var fastest : float = 0

func _ready() -> void:
	set_collision_layer_value(LAYER_BALL, true)
	set_collision_mask_value(LAYER_BALL, true)
	
	## needed for _on_body_entered to report collisions
	set_contact_monitor(true)
	set_max_contacts_reported(5)
	body_entered.connect(_on_body_entered)
	##

func _process(_delta: float) -> void:
	animated_sprite_ball.set_velocity(linear_velocity)
	animated_sprite_ball.rotation = rotation *- 1
	if linear_velocity.length() > fastest:
		fastest = linear_velocity.length()

func _set_shader_parameter(param: StringName, value: Variant) -> void:
	#print(get_material_override().get_shader_parameter(param))
	animated_sprite_ball.set_instance_shader_parameter(param, value)

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
	if body is Breakable:
		if get_mass() > Ball_Player.MASS_WALKING:  # precent player in walk mode from triggering the break
			body.remote_hit(self)
