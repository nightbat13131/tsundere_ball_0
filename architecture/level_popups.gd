class_name LevelPopUps extends CanvasLayer

enum PopupTypes {NA = 0, LEVEL_PAUSE = 1, LEVEL_WIN = 2, LEVEL_LOSS = 3, CLOSE_ALL = 10}

@export var pause_nodes: Array[Control]
@export var game_over_nodes: Array[Control]

static var _instance : LevelPopUps # : get = get_instance

@onready var menu_header: Label = %MenuHeader
@onready var level_select: ButtonSelf = %Level_Select
@onready var retry_button: ButtonSelf = %Retry_Button

"""
func _ready() -> void:
	deactivate()
	_instance = self
	level_select.pressed.connect(_on_request_level_select)
	retry_button.pressed.connect(_on_request_restart)
	for each_array : Array in [pause_nodes, game_over_nodes]:
		each_array.append(menu_header)
		each_array.append(level_select)
		each_array.append(retry_button)

func activate() -> void:
	set_physics_process(true)
	level_select.grab_focus(true)
	show()

func deactivate() -> void:
	hide()
	set_physics_process(false)

func _request_popup(popup_type: PopupTypes) -> void:
	print(popup_type, Time.get_date_dict_from_system() )
	var keep_array : Array[Control] = []
	match popup_type:
		PopupTypes.CLOSE_ALL:
			pass
			#deactivate()
		PopupTypes.LEVEL_PAUSE:
			
			keep_array = pause_nodes
			
		PopupTypes.LEVEL_WIN:
			
			keep_array = game_over_nodes
			
		PopupTypes.LEVEL_LOSS:
			
			keep_array = game_over_nodes
			
		_: 
			push_warning("LevelPopUps._request_popup no match for type ", popup_type)
	if keep_array.is_empty():
		deactivate()
	else: 
		activate()
		for each_child in %VBoxContainer.get_children():
			if keep_array.has(each_child):
				each_child.show()
			else:
				each_child.hide()

func _on_request_level_select() -> void:
	LevelSelect.request_activate()
	GameLevelUI.request_deactivate()
	deactivate()

func _on_request_restart() -> void: LevelSelect.request_reload()

static func get_instance() -> LevelPopUps: return _instance

static func request_popup(popup_type: PopupTypes) -> void:
	if get_instance():
		get_instance()._request_popup(popup_type)
	else: 
		push_warning("No LevelPopUps to request_popup")
"""
