@tool
class_name TileMapLayer_Enhanced extends TileMapLayer

enum TileType {WALLS, WALLS_OVER}

@export var _tile_type := TileType.WALLS

func _ready() -> void:
	position = position.snapped(Vector2.ONE)
	if Engine.is_editor_hint():
		return
	set_z_as_relative(false)
	set_y_sort_enabled(false) 
	match _tile_type:
		TileType.WALLS:
			set_z_index(UTILITIES.Z_Indexes.GROUND as int)
			## just doing all layers for now
			#get_tile_set().set_physics_layer_collision_mask(0, Ball.LAYER_BALL)
			#get_tile_set().set_physics_layer_collision_mask(Ball.LAYER_NPC_WALL, true)
		
			#get_tile_set().set_physics_layer_collision_layer(0, Ball.LAYER_NPC_WALL)
			#get_tile_set().set_physics_layer_collision_layer(0, Ball.LAYER_PC_WALL)
			pass
		TileType.WALLS_OVER:
			set_z_index(UTILITIES.Z_Indexes.OVERLAY as int)
