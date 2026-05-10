@tool
class_name TileMapLayer_Enhanced extends TileMapLayer

enum TileType {WALLS, WALLS_OVER}

@export var _tile_type := TileType.WALLS
@export var _selected_pallet := PaletteMaterial.PalletSelection.DEFAULT
var _material : PaletteMaterial

func _ready() -> void:
	position = position.snapped(Vector2.ONE)
	match _tile_type:
		TileType.WALLS:
			UTILITIES.apply_z_layer(self, UTILITIES.Z_Indexes.UNDER_WALL)
			## just doing all layers for now
			#get_tile_set().set_physics_layer_collision_mask(0, Ball.LAYER_BALL)
			#get_tile_set().set_physics_layer_collision_mask(Ball.LAYER_NPC_WALL, true)
		
			#get_tile_set().set_physics_layer_collision_layer(0, Ball.LAYER_NPC_WALL)
			#get_tile_set().set_physics_layer_collision_layer(0, Ball.LAYER_PC_WALL)
			pass
		TileType.WALLS_OVER:
			UTILITIES.apply_z_layer(self, UTILITIES.Z_Indexes.OVERLAY)
	apply_pallet()
	if Engine.is_editor_hint():
		return
	set_z_as_relative(false)
	set_y_sort_enabled(false) 
	

func apply_pallet() -> void:
	if _selected_pallet ==  PaletteMaterial.PalletSelection.DEFAULT:
		return
	_material = Floor.get_material_master().duplicate()
	set_material(_material)
	_material.set_pallet_selection(_selected_pallet)
