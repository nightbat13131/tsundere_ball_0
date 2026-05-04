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

var fastest : float = 0

func _ready() -> void:
	set_collision_layer_value(LAYER_BALL, true)
	set_collision_mask_value(LAYER_BALL, true)

func rolling_speed(speed: float) -> void:
	animated_sprite_ball.speed = speed

func roll_direction(radian: float) -> void:
	animated_sprite_ball.roll_direction(radian)

func toggle_rolling() -> void: animated_sprite_ball.is_rolling = !animated_sprite_ball.is_rolling

func _process(_delta: float) -> void:
	animated_sprite_ball.set_velocity(linear_velocity)
	animated_sprite_ball.rotation = rotation *- 1
	if linear_velocity.length() > fastest:
		fastest = linear_velocity.length()
		print(fastest)
