class_name Breakable extends StaticBody2D

signal used(ball: Ball)

const ANIMATION_BREAK = &"broke"
const ANIMATION_IDLE = &"default"

@export_category("GUI")

@export var goal: Goal_Info

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

var _break_next_frame := false # so that the hit frame bounces back the ball, and then is turned off the next frame. 
var _is_used := false # prevent multiple triggers in a frame

func _ready() -> void:
	set_collision_layer_value(Ball.LAYER_BALL, true)
	set_collision_mask_value(Ball.LAYER_BALL, true)
	
	animated_sprite_2d.play(ANIMATION_IDLE)
	if goal:
		goal = goal.duplicate(false)
		GoalTracker.goal_check_in.call_deferred(goal)

func remote_hit(thing: Node2D) -> void:
	if _break_next_frame or _is_used:
		return 
	_hit_by(thing)
	
func _physics_process(_delta: float) -> void:
	## collision detection moved to the BALL and it's advanced solver stuff.
	#var collision = move_and_collide(Vector2.ZERO, true)
	if _break_next_frame:
		_break()
		_break_next_frame = false
	if _is_used:
		return
	#if collision:
		##print(collision, collision.get_collider())
	#	_hit_by(collision.get_collider())

func _hit_by(thing: Node2D) -> void:
	if thing is Ball:
		#_break()
		_break_next_frame = true
		_is_used = true
		goal.broke()
		used.emit(thing)

func _break() -> void:
	Portrait.request_emotion(FaceTexture.Emotions.MAD)
	set_process_mode.call_deferred(Node.PROCESS_MODE_DISABLED)
	animated_sprite_2d.play(ANIMATION_BREAK)
