@tool
class_name Floor extends TextureRect

const CURSOR_PATH = 'uid://3vj7d6h5jtmr'
const PALLET_SWAP_MATERIAL_PATH = 'uid://74bd75wqgltb' # already has the image inserted

static var cursor : CustomCursor
static var pallet_material : PaletteMaterial

@export var _selected_pallet := PaletteMaterial.PalletSelection.DEFAULT
var _material : PaletteMaterial

func _ready() -> void:
	position = position.snapped(Vector2.ONE * 8)
	size = size.snapped(Vector2.ONE*8)
	set_expand_mode(TextureRect.EXPAND_IGNORE_SIZE)
	set_stretch_mode(TextureRect.STRETCH_TILE)
	apply_pallet()
	if Engine.is_editor_hint():
		return
	if cursor == null:
		cursor = load(CURSOR_PATH)
	if cursor:
		cursor.apply_to(self)

func apply_pallet() -> void:
	if _selected_pallet ==  PaletteMaterial.PalletSelection.DEFAULT:
		return
	_material = get_material_master().duplicate()
	set_material(_material)
	_material.set_pallet_selection(_selected_pallet)

static func get_material_master() -> PaletteMaterial:
	if pallet_material == null:
		pallet_material = load(PALLET_SWAP_MATERIAL_PATH)
	return pallet_material
