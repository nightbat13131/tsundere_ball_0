class_name Goal_Info extends Resource
## Current scorring is 
###  should_break == false
#### Counts towards total and counts as a fail if borken
##  should_break == true
#### does not count towards total and counts as a bonus point if borken

signal update_icon(texture)

## Aim for 36*36 or less
@export var ui_icon_init: Texture2D
## Aim for 36*36 or less
@export var ui_icon_broken: Texture2D
# lower number goes first
@export var sort_order := 1
@export var break_sound : AudioStream

var should_break := false

var _is_broken := false

func get_goal_icon() -> Texture2D:
	if _is_broken:
		return ui_icon_broken
	return ui_icon_init

func broke() -> void:
	_is_broken = true
	update_icon.emit(ui_icon_broken)
	SoundManager.request_sfx(break_sound)
	if is_failed():
		Portrait.something_bad()
	else:
		Portrait.something_good()

func total_count() -> int:
	if should_break: 
		return 0
	return 1

func is_failed() -> bool: 
	if should_break:
		return _is_broken
	else:
		return !_is_broken
