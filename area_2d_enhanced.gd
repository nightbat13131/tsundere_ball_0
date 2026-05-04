class_name Area2D_Enhanced extends Area2D

## alarm when a ball of the right kind enters

signal used(ball: Ball)

enum TrapModes {PILLAR, HOLE}

var _used := false # prevent triggering multiple times in the same frame

@export var dependency : Area2D_Enhanced

@export var _trap_mode := TrapModes.HOLE
@export var npc_type : Ball_NPC.NPCType

var is_locked := false

func _ready() -> void:
	if dependency:
		_hybernate()
		dependency.used.connect(_on_unlock)
		is_locked = true
	body_entered.connect(_on_body_entered)
	set_collision_mask_value(Ball_NPC.get_ball_collision_layer(npc_type), true)

func _hybernate() -> void:
	set_process_mode.call_deferred(Node.PROCESS_MODE_DISABLED)
	queue_redraw()

func _on_unlock(_ball: Ball)-> void: 
	is_locked = false
	set_process_mode.call_deferred(Node.PROCESS_MODE_INHERIT)
	queue_redraw()

func _on_body_entered(body: Node2D) -> void:
	if _used:
		return
	if body is Ball_NPC:
		_used = body.get_captured(_trap_mode)
		if !_used: # trapping for this body failed
			return
		used.emit(body)
		Portrait.request_emotion(Portrait.Emotions.BLUSHING)
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

func _draw() -> void:
	draw_circle(Vector2.ZERO, 30.0, Ball_NPC.get_color(npc_type), false, 3)
	if is_locked:
		draw_circle(Vector2.ZERO, 31.5, Color.DARK_GRAY, false, 3)
