class_name LevelInfo extends Resource

@export var level_name: String: get = get_level_name
@export var level_uid: String : get = get_level_path

@export var unlocked_by: LevelInfo
@export var unlocked_by_: LevelInfo
@export var unlocked_by__: LevelInfo
var _lockers : Array[LevelInfo] = [unlocked_by, unlocked_by_, unlocked_by__]

var _score := Score.Scores.LOCKED

# has to be called manually because it's a resource
func _ready() -> void: _connect_unlockers()

func is_locked() -> bool:
	for each_level : LevelInfo in _lockers:
		if each_level:
			if !each_level.is_complete():
				return true
	return false

func is_complete() -> bool: return ![Score.Scores.LOCKED, Score.Scores.NA].has(_score)

func get_score() -> Score.Scores: 
	if is_locked():
		return Score.Scores.LOCKED
	elif is_complete():
		return _score
	return Score.Scores.NA

func get_level_name() -> String:
	if level_name:
		return level_name
	return "Nameless Level"

func get_level_path() -> String: return level_uid

func get_emotion() -> FaceTexture.Emotions:
	return Score.score_to_emotion(get_score())

func set_score(score: Score) -> void:
	var old_score : int = get_score() as int
	var new_score := score.get_score()
	if new_score as int > old_score:
		_score = new_score
	changed.emit()

func _connect_unlockers() -> void:
	for each_info in _lockers:
		if each_info:
			if !each_info.changed.is_connected(changed.emit):
				each_info.changed.connect(changed.emit)
