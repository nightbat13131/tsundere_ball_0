class_name Breakable extends StaticBody2D


@export_category("GUI")

@export var goal: Goal_Info

@onready var sprite_2d: Sprite2D = %Sprite2D

func _ready() -> void:
	set_collision_layer_value(Ball.LAYER_BALL, true)
	set_collision_mask_value(Ball.LAYER_BALL, true)
	if goal:
		goal = goal.duplicate(false)
		GoalTracker.goal_check_in.call_deferred(goal)

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(Vector2.ZERO, true)
	if collision:
		print(collision, collision.get_collider())
		_hit_by(collision.get_collider())

func _hit_by(thing: Node2D) -> void:
	if thing is Ball:
		_break()
		goal.broke()

func _break() -> void:
	set_process_mode(Node.PROCESS_MODE_DISABLED)
	set_modulate(Color.RED)
