class_name StaticBody2d_Enhanced extends StaticBody2D

@export var block_player := true
@export var block_npc := true

func _ready() -> void:
	set_z_index(UTILITIES.Z_Indexes.TRAPS as int)
	set_collision_layer_value(Ball.LAYER_NPC_WALL, block_npc)
	set_collision_mask_value(Ball.LAYER_NPC, block_npc)
	
	set_collision_mask_value(Ball.LAYER_PC, block_player)
	set_collision_layer_value(Ball.LAYER_PC_WALL, block_player)
