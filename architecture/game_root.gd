class_name GameRoot extends Node2D

#@export var walking_mode : GUIDEMappingContext
#@export var rolling_mode : GUIDEMappingContext
#@export var ui_mode : GUIDEMappingContext
#@onready var sound_button: TextureButton = %SoundButton
#@onready var world: Node2D = %World
@onready var audio_manager: SoundManager = %AudioManager
#@onready var dark_panel: Panel = %DarkPanel


func _ready() -> void:
	#sound_button.toggled.connect(_on_sound_button_toggle)
	_on_sound_button_toggle(false)
	#printerr("debug world is active")

func _on_sound_button_toggle(is_pressed) -> void:
	#audio_manager.set_visible(is_pressed)
	#dark_panel.set_visible(is_pressed)
	if is_pressed:
		#GUIDE.disable_mapping_context(walking_mode)
		#GUIDE.enable_mapping_context(ui_mode)
		#world.set_process_mode(Node.PROCESS_MODE_DISABLED)
		pass
	else:
		#GUIDE.enable_mapping_context(walking_mode)
		#GUIDE.disable_mapping_context(ui_mode)
		#world.set_process_mode(Node.PROCESS_MODE_INHERIT)
		pass
