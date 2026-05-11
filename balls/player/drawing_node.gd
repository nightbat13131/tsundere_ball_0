class_name DrawingNode extends Node2D

@export var draw_master: Ball_Player

func _ready() -> void:
	UTILITIES.apply_z_layer(self, UTILITIES.Z_Indexes.OVERLAY)

func _draw() -> void:
	assert(draw_master != null, "DrawingNode needs a draw_master to tell it what to do")
	draw_master.request_draw(self)
