class_name FaceTexture extends AtlasTexture

enum Emotions {
	HEART_SMILE = 0,
	BIG_SMILE = 1,
	SMILE = 2, 
	HALF_FROWN = 3, 
	SHOUT = 4,
	VERY_ANGRY = 5,
	BLUSHING = 6, 
	SMILE_UWU = 7, 
	BLUSHING_WUW = 8,
	WINK_UWU = 9, 
	EYES_CLOSED_UWU = 10, 
	FULL_UWU = 11, 
	FROWN = 12, 
	MUSTACHIO = 13,
	
	BLANK =  14,
	LOCKED = 15, 
	UNKONWN = 16,
	
	IDLE = SMILE, 
	MAD = SHOUT, 
	
	BROKE_SOMETHING = SHOUT,
	
	SCORE_0 = VERY_ANGRY,
	SCORE_1 = FROWN,
	SCORE_2 = SMILE,
	SCORE_3 = SMILE_UWU,
	SCORE_4 = HEART_SMILE,

} # number matches with expression order

func init() -> void:
	region.size.x = get_image().get_size().y
	set_emotion(Emotions.IDLE)

func set_emotion(emotion: Emotions) -> void:
	region.position.x = region.size.x * (emotion as int)
