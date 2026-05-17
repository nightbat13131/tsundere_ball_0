@tool
class_name Breakable_Car extends Breakable


const ANIMATION_BOOM_4 = &'broke'
const ANIMATION_BOOM_3 = &'boom3'
const ANIMATION_BOOM_2 = &'boom2'
const ANIMATION_BOOM_1 = &'boom1'

const MAX_HP = 4

@onready var broke_sprite: Sprite2D = %Broke_Sprite
@onready var car_sprite: Sprite2D = %CarSprite
@export var damage_sounds : Array[AudioStream]


var _hp := MAX_HP: set = _set_hp

func _set_hp(new_hp: int) -> void:
	_hp = new_hp
	_broke_percent(1.0-_hp/float(MAX_HP))
	match _hp:
		4:
			animated_sprite_2d.play(ANIMATION_IDLE)
		3: 
			animated_sprite_2d.play(ANIMATION_BOOM_1)
			SoundManager.request_sfx(damage_sounds.pick_random())
		2:
			animated_sprite_2d.play(ANIMATION_BOOM_2)
			SoundManager.request_sfx(damage_sounds.pick_random())
		1:
			animated_sprite_2d.play(ANIMATION_BOOM_3)
			SoundManager.request_sfx(damage_sounds.pick_random())
		0:
			_hit_by()

func _ready() -> void:
	super._ready()
	if Engine.is_editor_hint():
		#broke_sprite.get_texture().set_region_rect(car_sprite.get_texture)
		car_sprite.region_rect.size = car_sprite.region_rect.size.snapped(Vector2.ONE*2)
		broke_sprite.set_region_rect(car_sprite.get_region_rect())
		return
	_hp = _hp


func remote_hit(thing: Node2D) -> void:
	## complete overwrite of method
	if thing is Ball:
		if thing.get_mass() > Ball_Player.MASS_WALKING:  # prevent player in walk mode from triggering the break when bad
			_hp -= 1
		#elif goal.should_break:
			#_hp -= 1

func _break() -> void:
	super._break()
	# 

func _broke_percent(percent: float) -> void:
	broke_sprite.modulate.a = percent
	if is_equal_approx(percent, 1.0):
		car_sprite.hide()
	pass
	
