class_name SaveFileResource extends Resource

const KEY_0NAME = &'save_name'
const KEY_0SETTINGS = &'settings'
const KEY_1SOUND = &'sound'
const KEY_2VOLUME_MASTER = &'master_volume'
const KEY_2VOLUME_MUSIC = &'music_volume'
const KEY_2VOLUME_SFX = &'sfx_volume'
const KEY_2MUTE_SOUND = &'mute_sound'
const KEY_1MISC = &'misc'
const KEY_0GAME_PROGRESS = &'game_progress'
const KEY_1GAME_LEVELS = &'level_ids_completed'

var save_index := -1
var name := 'New Game'
var sound_mute_all := false
var sound_master := .75
var sound_music := .75
var sound_sfx := .75
var completed_levels : Array[String]
var level_scores : Dictionary[String, Score.Scores] = {}

func level_completed(level_id: String) -> void:
	if !completed_levels.has(level_id):
		completed_levels.append(level_id)

func update_level_score(level_id: String, score: Score.Scores) -> void:
	#var old = level_scores.get(level_id, Score.Scores.LOCKED)
	level_scores[level_id] = score # as int

func to_dict() -> Dictionary:
	var _data : Dictionary = {}
	_data[KEY_0NAME] = name
	_data[KEY_0SETTINGS] = {}
	_data[KEY_0SETTINGS][KEY_1SOUND] = {}
	_data[KEY_0SETTINGS][KEY_1SOUND][KEY_2MUTE_SOUND] = sound_mute_all
	_data[KEY_0SETTINGS][KEY_1SOUND][KEY_2VOLUME_MASTER] = sound_master
	_data[KEY_0SETTINGS][KEY_1SOUND][KEY_2VOLUME_MUSIC] = sound_music
	_data[KEY_0SETTINGS][KEY_1SOUND][KEY_2VOLUME_MUSIC] = sound_sfx
	_data[KEY_0SETTINGS][KEY_1MISC] = {}
	_data[KEY_0GAME_PROGRESS] = {}
	_data[KEY_0GAME_PROGRESS][KEY_1GAME_LEVELS] = completed_levels
	return _data

func from_dict(_data: Dictionary, index: int) -> void:
	#prints("a", index, _data)
	save_index = index
	name = _data.get(KEY_0NAME, name)
	var _settings = _data.get(KEY_0SETTINGS, {})
	var _sound = _settings.get(KEY_1SOUND, {})
	sound_mute_all = _sound.get(KEY_2MUTE_SOUND, sound_mute_all)
	sound_master = _sound.get(KEY_2VOLUME_MASTER, sound_master)
	sound_music = _sound.get(KEY_2VOLUME_MUSIC, sound_music)
	sound_sfx = _sound.get(KEY_2VOLUME_SFX, sound_sfx)
	var _progress = _data.get(KEY_0GAME_PROGRESS, {})
	var levels: Array = _progress.get(KEY_1GAME_LEVELS, [])
	for each_item in levels:
		each_item = each_item as String
		completed_levels.append(each_item)
	if !levels.is_empty():
		name = 'Continue'



#region JSON expectation
"""[
{
	"name": Empty, 
	"settings": {
		"sound": {
			"master_volume": 50.0,
			"music_volume": 50.0,
			"sfx_volumd": 50.0
		},
		"misc": {
		}
	},
	"progress": {
		"level_ids": []
	},
},
{},
{}
]"""

#endregion
