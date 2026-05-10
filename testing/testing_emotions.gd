extends OptionButton



func _ready() -> void:
	item_selected.connect(_on_item_selected)
	for each_ in FaceTexture.Emotions:
		add_item(str(each_), FaceTexture.Emotions[each_] )

func _on_item_selected(index) -> void:
	Portrait.request_emotion(get_item_id(index) as FaceTexture.Emotions)
