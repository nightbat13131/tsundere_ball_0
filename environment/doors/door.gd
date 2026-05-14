@tool
class_name Door extends StaticBody2d_Enhanced

signal opening

const ANIMATION_CLOSED = &"default"
const ANIMATION_OPENING = &"opening"

const SOUND_PATH = 'uid://3rclkpk67o37'
static var sound : AudioStream

@export var _dependency_condition := UTILITIES.Conditions.AND
@export var dependencys : Array[Area2D_Enhanced] = [null]
var _dependencys : Array[Area2D_Enhanced] = []

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@export var alt_sprite: AnimatedSprite2D

var _is_unlocked := false

func _ready() -> void:
	super._ready()
	UTILITIES.apply_z_layer(self, UTILITIES.Z_Indexes.DOORS)
	set_modulate(Color(1.0,1.0,1.0,.75))
	animated_sprite_2d.play(ANIMATION_CLOSED)
	if alt_sprite:
		alt_sprite.play(ANIMATION_CLOSED)
	if Engine.is_editor_hint():
		position = position.snapped(Vector2.ONE*8)
		return
	_connect_interactions()
	animated_sprite_2d.set_process_mode.call_deferred(Node.PROCESS_MODE_ALWAYS)

func _connect_interactions() -> void:
	for each_dp in dependencys:
		if each_dp:
			_dependencys.append(each_dp)
			each_dp.used.connect(_on_unlock_check)

func _on_unlock_check(_ball: Ball, trap: Trap)-> void: 
	if _dependency_condition == UTILITIES.Conditions.OR:
		_dependencys = []
	else:
		_dependencys.erase(trap)
	if _dependencys.is_empty():
		_do_unlock()

func is_locked() -> bool: return !_dependencys.is_empty()

func _do_unlock() -> void:
	if _is_unlocked: ## prevent repeated triggers
		return
	_is_unlocked = true
	opening.emit()
	animated_sprite_2d.play(ANIMATION_OPENING)
	if alt_sprite:
		alt_sprite.play(ANIMATION_OPENING)
	_play_sound()
	for each_child in get_children():
		if each_child is CollisionShape2D:
			each_child.set_disabled.call_deferred(true)
	#set_process_mode.call_deferred(Node.PROCESS_MODE_DISABLED) # breaks animation and not even removing the blocking

func _play_sound() -> void:
	if sound == null:
		sound = load(SOUND_PATH)
	SoundManager.request_sfx(sound)

func _draw() -> void:
	if Engine.is_editor_hint():
		_draw_engine()

func _draw_engine() -> void:
	for dependency in dependencys:
		if dependency:
			draw_line(Vector2.ONE * 5, to_local(dependency.position), Color.PALE_GREEN, Trap.THICKNESS)
