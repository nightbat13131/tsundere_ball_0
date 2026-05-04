extends OptionButton

#@export var portrait: Portrait

func _ready() -> void:
	item_selected.connect(_on_item_selected)
	for each_ in Portrait.Emotions:
		add_item(str(each_), Portrait.Emotions[each_] )

func _on_item_selected(index) -> void:
	#if portrait:
	#	portrait.request_emotion(get_item_id(index) as Portrait.Emotions)
	Portrait.request_emotion(get_item_id(index) as Portrait.Emotions)
