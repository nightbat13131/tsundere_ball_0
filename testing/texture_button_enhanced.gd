class_name TextureButton_Enhanced extends TextureButton

static var sfx_sound: AudioStream = load('uid://dtgqshvkyd15n')

#@export var mouse_cursor: CustomMouse

func _ready() -> void:
	#if mouse_cursor:
	#	mouse_cursor.apply_to(self)
	#set_z_index(Utility.UI_OVER_APPERANCE)
	set_z_as_relative(false)
	#set_default_cursor_shape(CustomMouse.BUTTONS as Control.CursorShape)
	if !Engine.is_editor_hint():
		pressed.connect(self._on_pressed)
		pressed.connect(self._press_sound)

# sound can be replaced by assigning differnet path in _ready() in children.
func _press_sound() ->void: SoundManager.request_sfx(sfx_sound)

func _on_pressed() -> void: 
	#printerr("ButtonSelf has been pressed, but _on_pressed() not overrode. Name:" , self.name)
	#pressed.emit() # Children need to do a special emit or function
	pass


func remote_press() -> void: 
	_on_pressed()
	_press_sound()
