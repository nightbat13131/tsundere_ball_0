@tool
class_name Ball_NPC extends Ball


@export var red_sprites : SpriteFrames
@export var blue_sprites : SpriteFrames
@export var yellow_sprites : SpriteFrames



func _ready() -> void:
	super._ready()
	if _npc_type == Ball.NPCType.PLAYER:
		push_error(self, " NPC type not set correclty")
	
	UTILITIES.apply_z_layer(self, UTILITIES.Z_Indexes.BALL_NPC)
	if Engine.is_editor_hint():
		return
	set_animation()
	
	set_collision_layer_value(Ball.LAYER_NPC, true)
	set_collision_layer_value(get_ball_collision_layer(_npc_type), true)
	set_collision_mask_value(Ball.LAYER_NPC_WALL, true)
	_set_shader_parameter(UTILITIES.SHADER_OUTLINE_COLOR, UTILITIES.COLOR_BORDER_BOUNCY)

func set_animation() -> void:
	match _npc_type:
		NPCType.RED:
			animated_sprite_ball.set_sprite_frames(red_sprites)
		NPCType.YELLOW:
			animated_sprite_ball.set_sprite_frames(yellow_sprites)
		NPCType.BLUE:
			animated_sprite_ball.set_sprite_frames(blue_sprites)

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_circle(Vector2.ZERO, BALL_RADIUS * 1.5, get_color(_npc_type))

static func get_ball_collision_layer(npc_type: NPCType) -> int:
	match npc_type:
		NPCType.RED:
			return LAYER_NPC_RED
		NPCType.YELLOW:
			return LAYER_NPC_YELLOW
		NPCType.BLUE:
			return LAYER_NPC_BLUE
		NPCType.PLAYER:
			return LAYER_PC
	return LAYER_NPC
