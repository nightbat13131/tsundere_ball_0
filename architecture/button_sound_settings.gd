extends ButtonSelf

@export var action_remote_press: GUIDEAction

func _ready() -> void:
	super._ready()
	if action_remote_press:
		action_remote_press.triggered.connect(_on_pressed)

func _on_pressed() -> void: SoundManager.toggle_audio_settings()
