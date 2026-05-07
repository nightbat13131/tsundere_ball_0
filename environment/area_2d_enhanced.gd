@tool
class_name Area2D_Enhanced extends Area2D


@export var npc_type : Ball_NPC.NPCType


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	if Engine.is_editor_hint():
		position = position.snapped(Vector2.ONE*4)
		return
	set_collision_mask_value(Ball_NPC.get_ball_collision_layer(npc_type), true)

func _on_body_entered(_body: Node2D) -> void: return
