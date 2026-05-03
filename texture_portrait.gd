class_name Portrait extends TextureRect

enum Emotions {IDLE = 0, MAD = 1, BLUSHING = 2}


@export var idle: CompressedTexture2D
@export var mad: CompressedTexture2D
@export var blushing: CompressedTexture2D

func request_emotion(emotion: Emotions) -> void:
	var tex : CompressedTexture2D
	match emotion:
		Emotions.MAD:
			if mad:
				tex = mad
		Emotions.BLUSHING:
			if blushing:
				tex = blushing
	if tex == null:
		tex = idle
	set_texture(tex)
	
