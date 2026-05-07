class_name LoadingScreen extends CanvasLayer

## load level
### Blue spiral gradiant
### told start - turn on 0 -> 1
### wait for complete 
### turn off 1 -> 0

## Loap map
### told start - turn on 0 -> 1
### swtich to map 
### turn off 1 -> 0

const SHADER_LUMINANCE_CUTOFF = &'luminance_cutoff'
const DURATION = .75
const SHADER_OPEN = 0.0
const SHADER_CLOSED = 1.0

signal curtain_closed
signal curtain_open

var _closed_percent := 0.0 : set = _set_closed_percent

#static var _instance : LoadingScreen

@onready var panel: Panel = %Panel

const DEFAULT_DURATION := 1.0

var _tween: Tween


func _setup_tween() -> void:
	if _tween:
		if _tween.is_valid():
			_tween.kill()
	_tween = get_tree().create_tween()
	_tween.set_ease(Tween.EASE_IN_OUT)
	_tween.set_trans(Tween.TRANS_CUBIC)

func close_curtain() -> void:
	_setup_tween()
	_tween.tween_method(_set_closed_percent, _closed_percent, SHADER_CLOSED, DURATION)

func open_curtain() -> void:
	_setup_tween()
	_tween.tween_method(_set_closed_percent, _closed_percent, SHADER_OPEN, DURATION)
	

func force_closed() -> void:
	_set_closed_percent(SHADER_CLOSED)
	#panel.set_mouse_filter(Control.MOUSE_FILTER_STOP)

func _set_closed_percent(value: float) -> void:
	_closed_percent = value
	panel.set_instance_shader_parameter(SHADER_LUMINANCE_CUTOFF, _closed_percent)
	if _closed_percent >= SHADER_CLOSED:
		curtain_closed.emit()
	elif _closed_percent <= SHADER_OPEN:
		curtain_open.emit()

func on_app_load() -> void:
	await get_tree().create_timer(.5)
	force_closed()
	
	open_curtain()

#func _set_shader_parameter(param: StringName, value: Variant) -> void:
	##print(get_material_override().get_shader_parameter(param))
	#panel.set_instance_shader_parameter(param, value)
