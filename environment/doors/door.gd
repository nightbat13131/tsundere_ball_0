@tool
class_name door extends StaticBody2d_Enhanced

const ANIMATION_CLOSED = &"default"
const ANIMATION_OPENING = &"opening"

const SOUND_PATH = 'uid://domubmw5gl2m0'
static var sound : AudioStream

@export var dependency : CollisionObject2D

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

var is_locked := true

func _ready() -> void:
	super._ready()
	if Engine.is_editor_hint():
		position = position.snapped(Vector2.ONE*8)
		return
	if dependency:
		if dependency is Area2D_Enhanced:
			dependency.used.connect(_on_dependency_used)
	animated_sprite_2d.play(ANIMATION_CLOSED)
	animated_sprite_2d.set_process_mode.call_deferred(Node.PROCESS_MODE_ALWAYS)

func _on_dependency_used(_node: Node2D) -> void:
	_unlock.call_deferred()

func _unlock() -> void:
	set_process_mode.call_deferred(Node.PROCESS_MODE_DISABLED)
	animated_sprite_2d.play(ANIMATION_OPENING)
	_play_sound()

func _play_sound() -> void:
	if sound == null:
		sound = load(SOUND_PATH)
	SoundManager.request_sfx(sound)


func _draw() -> void:
	if Engine.is_editor_hint() and dependency:
		draw_line(Vector2.ZERO, to_local(dependency.position), Color.GRAY, Trap.THICKNESS)
