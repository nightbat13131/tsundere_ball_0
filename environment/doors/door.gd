@tool
class_name door extends StaticBody2d_Enhanced

const ANIMATION_CLOSED = &"default"
const ANIMATION_OPENING = &"opening"

const SOUND_PATH = 'uid://domubmw5gl2m0'
static var sound : AudioStream

@export var dependency : CollisionObject2D:
	set(value):
		dependency = value
		queue_redraw()

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@export var alt_sprite: AnimatedSprite2D

var is_locked := true

func _ready() -> void:
	super._ready()
	set_modulate(Color(1.0,1.0,1.0,.75))
	if Engine.is_editor_hint():
		position = position.snapped(Vector2.ONE*8)
		return
	if dependency:
		if dependency is Area2D_Enhanced:
			dependency.used.connect(_on_dependency_used)
	animated_sprite_2d.play(ANIMATION_CLOSED)
	if alt_sprite:
		alt_sprite.play(ANIMATION_CLOSED)
	animated_sprite_2d.set_process_mode.call_deferred(Node.PROCESS_MODE_ALWAYS)

func _on_dependency_used(_node: Node2D) -> void:
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
	if Engine.is_editor_hint() and dependency:
		draw_line(Vector2.ZERO, to_local(dependency.position), Color.GRAY, Trap.THICKNESS)
