@tool
class_name TilesOverDoors extends TileMapLayer_Enhanced
## makes wall disapear when door opens

@export var door : Door

func _ready() -> void:
	super._ready()
	UTILITIES.apply_z_layer(self, UTILITIES.Z_Indexes.OVER_DOORS)
	if door:
		set_modulate(Color.WHITE)
		if !Engine.is_editor_hint():
			door.opening.connect(_on_open)
	else:
		set_modulate(Color.BLACK)


func _on_open() -> void:
	hide()
