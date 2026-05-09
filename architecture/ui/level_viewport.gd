@tool
class_name LevelViewport extends SubViewport

enum Modes {NA = 0, _2D = 2, _3D = 3 }

var _sub_viewport_container: SubViewportContainer

func _ready() -> void:
	if Engine.is_editor_hint():
		size = get_viewport_size()
		#size.x = ProjectSettings.get_setting('display/window/size/viewport_width')
		#size.y = ProjectSettings.get_setting('display/window/size/viewport_height') - GameLevelUI.UI_BANNER_HEIGHT
		return
	configure_for_2d()
	
	if get_parent() is SubViewportContainer:
		# Fixing this anit-practive would just move this code up one level
		_sub_viewport_container = get_parent()
	else:
		push_error("LevelViewport has a non SubViewportContainer parent")

func clear_old_level() -> void:
	for old in get_children():
		old.queue_free()

func add_level(level: Level) -> void:
	clear_old_level()
	add_child(level)

func deactivate() -> void:
	## TODO going to have to remove Level in smarter way?
	for old in get_children():
		old.queue_free()

func configure_for_2d() -> void:
	## middle mouse button pressed not being detected? 
	# _sub_viewport_container.set_mouse_filter(Control.MOUSE_FILTER_PASS) ## scrolling works, 2d buttons work, no middle mouse button, no mouse movement
	# _sub_viewport_container.set_mouse_filter(Control.MOUSE_FILTER_IGNORE) ## scrolling works, 2d buttons fail, no middle mouse button, no mouse movement
	# _sub_viewport_container.set_mouse_filter(Control.MOUSE_FILTER_STOP) ## scrolling works, 2d buttons work, no middle mouse button, no mouse movement
	#_sub_viewport_container.set_mouse_target(true) ## matches on old configs
	set_physics_object_picking(false) # otherwise mouse scrolling not recognized in viewport
	pass

func _unhandled_input(_event: InputEvent) -> void:
	## overcomes the viewport seemily blocking mouse movement problems I was having for 3D and suddnely 2D..
	#GUIDE.inject_input(_event)
	pass

static func get_viewport_size() -> Vector2: 
	var a = Vector2.ONE
	a.x = ProjectSettings.get_setting('display/window/size/viewport_width') - GameLevelUI.UI_BANNER_HEIGHT
	a.y = ProjectSettings.get_setting('display/window/size/viewport_height') - GameLevelUI.UI_BANNER_HEIGHT*2
	a = a.snapped(Vector2.ONE*16)
	return a
