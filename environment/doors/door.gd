@tool
class_name Door extends StaticBody2d_Enhanced

const ANIMATION_CLOSED = &"default"
const ANIMATION_OPENING = &"opening"

const SOUND_PATH = 'uid://domubmw5gl2m0'
static var sound : AudioStream

@export var dependency : Trap:
	set(value):
		dependency = value
		queue_redraw()
@export var dependency_ : Trap:
	set(value):
		dependency_ = value
		queue_redraw()
@export var dependency__ : Trap:
	set(value):
		dependency__ = value
		queue_redraw()

var _dependencies : Array[Trap]

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@export var alt_sprite: AnimatedSprite2D

func _ready() -> void:
	super._ready()
	UTILITIES.apply_z_layer(self, UTILITIES.Z_Indexes.DOORS)
	set_modulate(Color(1.0,1.0,1.0,.75))
	if dependency:
		dependency.used.connect(_on_dependency_used)
		_dependencies.append(dependency)
	if dependency_:
		dependency_.used.connect(_on_dependency_used)
		_dependencies.append(dependency_)
	if dependency__:
		dependency__.used.connect(_on_dependency_used)
		_dependencies.append(dependency__)
	animated_sprite_2d.play(ANIMATION_CLOSED)
	if alt_sprite:
		alt_sprite.play(ANIMATION_CLOSED)
	if Engine.is_editor_hint():
		position = position.snapped(Vector2.ONE*8)
		return
	animated_sprite_2d.set_process_mode.call_deferred(Node.PROCESS_MODE_ALWAYS)

func is_locked() -> bool:
	for each_trap in _dependencies:
		if !each_trap.is_used():
			return true
	return false

func _on_dependency_used(_node: Node2D) -> void:
	if !is_locked():
		_unlock.call_deferred()

func _unlock() -> void:
	
	animated_sprite_2d.play(ANIMATION_OPENING)
	if alt_sprite:
		alt_sprite.play(ANIMATION_OPENING)
	_play_sound()
	for each_child in get_children():
		if each_child is CollisionShape2D:
			each_child.set_disabled(true)
	#set_process_mode.call_deferred(Node.PROCESS_MODE_DISABLED) # breaks animation and not even removing the blocking

func _play_sound() -> void:
	if sound == null:
		sound = load(SOUND_PATH)
	SoundManager.request_sfx(sound)

func _draw() -> void:
	if Engine.is_editor_hint():
		for each_trap: Trap in _dependencies:
			draw_line(Vector2.ZERO, to_local(each_trap.position), Color.GRAY, Trap.THICKNESS)
