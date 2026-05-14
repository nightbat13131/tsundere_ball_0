@tool
class_name Breakable extends StaticBody2D

signal used(ball: Ball)

const ANIMATION_BREAK = &"broke"
const ANIMATION_IDLE = &"default"
const ANIMATION_MAD = &'mad'

@export_category("GUI")

@export var goal: Goal_Info

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var mad_man: AnimatedSprite2D = %mad_man

var _break_next_frame := false # so that the hit frame bounces back the ball, and then is turned off the next frame. 
var _is_used := false # prevent multiple triggers in a frame

func _ready() -> void:
	UTILITIES.apply_z_layer(self, UTILITIES.Z_Indexes.DECORATIONS)
	UTILITIES.apply_z_layer(mad_man, UTILITIES.Z_Indexes.SUB_OVERLAY)
	animated_sprite_2d.play(ANIMATION_IDLE)
	mad_man.play(ANIMATION_IDLE)
	if Engine.is_editor_hint():
		return
	set_collision_layer_value(Ball.LAYER_BALL, true)
	set_collision_mask_value(Ball.LAYER_BALL, true)
	if goal:
		goal = goal.duplicate(false)
		GoalTracker.goal_check_in.call_deferred(goal)

#func is_break_good() -> bool: return goal.should_break

func remote_hit(thing: Node2D) -> void:
	if thing is Ball:
		if thing.get_mass() > Ball_Player.MASS_WALKING:  # prevent player in walk mode from triggering the break when bad
			_hit_by(thing)
		elif goal.should_break:
			_hit_by(thing)

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
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
	for each_child in get_children():
		if each_child is CollisionShape2D:
			each_child.set_disabled(true)
	#set_process_mode.call_deferred(Node.PROCESS_MODE_DISABLED)
	animated_sprite_2d.play(ANIMATION_BREAK)
	mad_man.play(ANIMATION_MAD)
