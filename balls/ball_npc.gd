class_name Ball_NPC extends Ball

enum NPCType {RED, YELLOW, BLUE}

@export var _npc_type:= NPCType.RED

func _ready() -> void:
	super._ready()
	set_collision_layer_value(Ball.LAYER_NPC, true)
	#set_collision_mask_value(Ball.LAYER_NPC, true)
	
	set_collision_layer_value(get_ball_collision_layer(_npc_type), true)
	#set_collision_mask_value(get_ball_collision_layer(_npc_type), true)
	set_collision_mask_value(Ball.LAYER_NPC_WALL, true)
	set_modulate(get_color(_npc_type))

static func get_color(npc_type: NPCType) -> Color:
	match npc_type:
		NPCType.RED:
			return Color.RED
		NPCType.YELLOW:
			return Color.YELLOW
		NPCType.BLUE:
			return Color.BLUE
	return Color.WHITE

static func get_ball_collision_layer(npc_type: NPCType) -> int:
	match npc_type:
		NPCType.RED:
			return LAYER_NPC_RED
		NPCType.YELLOW:
			return LAYER_NPC_YELLOW
		NPCType.BLUE:
			return LAYER_NPC_BLUE
	return LAYER_NPC
