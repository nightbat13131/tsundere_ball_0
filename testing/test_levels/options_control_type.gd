extends OptionButton

@export var ball: Ball_Player

func _ready() -> void:
	item_selected.connect(_on_item_selected)
	for each_ in Ball_Player.ContolerType:
		add_item(str(each_), Ball_Player.ContolerType[each_] )
	_on_item_selected.call_deferred(0)

func _on_item_selected(index) -> void:
	if ball:
		ball.control_type = get_item_id(index) as Ball_Player.ContolerType
