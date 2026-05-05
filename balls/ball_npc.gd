class_name Ball_NPC extends Ball

@export var _npc_type:= NPCType.RED

var _is_trapped := false

func _ready() -> void:
	super._ready()
	set_z_index(UTILITIES.Z_Indexes.BALL_NPC as int)
	set_collision_layer_value(Ball.LAYER_NPC, true)
	set_collision_layer_value(get_ball_collision_layer(_npc_type), true)
	set_collision_mask_value(Ball.LAYER_NPC_WALL, true)
	_set_shader_parameter(UTILITIES.SHADER_OUTLINE_COLOR, UTILITIES.COLOR_BORDER_BOUNCY)
	_set_shader_parameter(UTILITIES.SHADER_MODULATE_COLOR, get_color(_npc_type)) 

func get_captured(trap_mode: Area2D_Enhanced.TrapModes) -> bool:
	if _is_trapped: # first trap takes priority 
		return false
	set_z_index(UTILITIES.Z_Indexes.IN_TRAP as int)
	set_freeze_enabled.call_deferred(true)
	animated_sprite_ball.freeze()
	set_freeze_mode(RigidBody2D.FREEZE_MODE_KINEMATIC)
	match trap_mode:
		Area2D_Enhanced.TrapModes.PILLAR:
			_set_shader_parameter(UTILITIES.SHADER_OUTLINE_COLOR, UTILITIES.COLOR_BORDER_OBSTICAL)
		Area2D_Enhanced.TrapModes.HOLE:
			_set_shader_parameter(UTILITIES.SHADER_MODULATE_COLOR, get_color(_npc_type).darkened(UTILITIES.DARKEN_HOLE))
			_set_shader_parameter(UTILITIES.SHADER_OUTLINE_COLOR, UTILITIES.COLOR_BORDER_NON_ENTITIY)
			collision_shape_2d.set_disabled.call_deferred(true)
			pass
	return true

static func get_ball_collision_layer(npc_type: NPCType) -> int:
	match npc_type:
		NPCType.RED:
			return LAYER_NPC_RED
		NPCType.YELLOW:
			return LAYER_NPC_YELLOW
		NPCType.BLUE:
			return LAYER_NPC_BLUE
	return LAYER_NPC
