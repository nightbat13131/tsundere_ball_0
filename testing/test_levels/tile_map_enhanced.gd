class_name TileMapLayer_Enhanced extends TileMapLayer

enum TileType {WALLS, FLOOR}

@export var _tile_type := TileType.WALLS

func _ready() -> void:
	if _tile_type == TileType.WALLS:
		get_tile_set().set_physics_layer_collision_mask(0, Ball.LAYER_BALL)
		#get_tile_set().set_physics_layer_collision_mask(Ball.LAYER_NPC_WALL, true)
	
		get_tile_set().set_physics_layer_collision_layer(0, Ball.LAYER_NPC_WALL)
		get_tile_set().set_physics_layer_collision_layer(0, Ball.LAYER_PC_WALL)
