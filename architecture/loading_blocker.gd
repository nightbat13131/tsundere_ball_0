class_name LoadingCurtain extends CanvasLayer

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

static var _instance: LoadingCurtain


var _closed_percent := 0.0 : set = _set_closed_percent
@onready var panel: Panel = %Panel

static func is_open() -> bool:
	if _instance:
		return is_equal_approx(_instance._closed_percent , SHADER_OPEN)
	return true

static func is_closed() -> bool:
	if _instance:
		prints(_instance._closed_percent, SHADER_CLOSED)
		return is_equal_approx(_instance._closed_percent , SHADER_CLOSED)
	return true

func _ready() -> void:
	_instance = self

func _get_tween() -> Tween:
	var _tween: Tween
	_tween = get_tree().create_tween()
	_tween.set_ease(Tween.EASE_IN_OUT)
	_tween.set_trans(Tween.TRANS_CUBIC)
	return _tween

static func request_close() -> void:
	if _instance:
		_instance.close_curtain()

func close_curtain() -> void:
	var _tween: Tween = _get_tween()
	_tween.tween_method(_set_closed_percent, _closed_percent, SHADER_CLOSED, DURATION)
	_tween.tween_callback(curtain_closed.emit)

static func request_open() -> void:
	if _instance:
		_instance.open_curtain()

func open_curtain() -> void:
	var _tween: Tween = _get_tween()
	_tween.tween_method(_set_closed_percent, _closed_percent, SHADER_OPEN, DURATION)

func force_closed() -> void:
	_set_closed_percent(SHADER_CLOSED)

func _set_closed_percent(value: float) -> void:
	_closed_percent = value
	panel.set_instance_shader_parameter(SHADER_LUMINANCE_CUTOFF, _closed_percent)
	if _closed_percent >= SHADER_CLOSED:
		curtain_closed.emit()
	elif _closed_percent <= SHADER_OPEN:
		curtain_open.emit()

func on_app_load() -> void:
	force_closed()
	await get_tree().create_timer(.25).timeout
	open_curtain()
