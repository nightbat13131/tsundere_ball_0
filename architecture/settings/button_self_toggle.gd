extends ButtonSelf

@export var pressed_icon : Texture2D
@export var unpressed_icon : Texture2D

func _ready() -> void:
	set_toggle_mode(true)
	toggled.connect(_on_toggle)

func _on_pressed() -> void: pass


func _on_toggle(_is_pressed: bool) -> void:
	if _is_pressed:
		set_button_icon(pressed_icon)
	else:
		set_button_icon(unpressed_icon) 
