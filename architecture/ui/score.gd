class_name Score extends Resource

## If I add scores, I need to adjust the LevelInfo unlock check
enum Scores {LOCKED = -1, NA = 0, FULL_FAIL = 1, BAD = 2, MID = 3, GOOD = 4, FULL_WIN = 5}

var _goals : Array[Goal_Info]
var _total := 0

func add_goal(goal: Goal_Info) -> void:
	if !_goals.has(goal):
		_total += goal.total_count()
		_goals.append(goal)
		#goal.changed.connect(changed.emit)

func get_total() -> int: return _total

func get_failed() -> int:
	var count := 0
	for each_goal in _goals:
		count += each_goal.fail_count()
	return count

func get_score() -> Scores: return ratio_to_score(get_failed(), get_total())

func get_emotion() -> FaceTexture.Emotions: return score_to_emotion(get_score())

static func score_to_emotion(score: Scores) -> FaceTexture.Emotions:
	match score:
		Scores.LOCKED:
			return FaceTexture.Emotions.LOCKED
		Scores.NA:
			return FaceTexture.Emotions.UNKONWN
		Scores.FULL_FAIL:
			return FaceTexture.Emotions.SCORE_0
		Scores.BAD:
			return FaceTexture.Emotions.SCORE_1
		Scores.MID:
			return FaceTexture.Emotions.SCORE_2
		Scores.GOOD:
			return FaceTexture.Emotions.SCORE_3
		Scores.FULL_WIN:
			return FaceTexture.Emotions.SCORE_4
	return FaceTexture.Emotions.BLANK

static func ratio_to_score(fail: int, total: int) -> Scores:
	var new_score := Scores.MID
	var ratio : float = fail / float(total)
	if fail <= 0:
		new_score = Scores.FULL_WIN
	elif fail >= total:
		new_score = Scores.FULL_FAIL
	elif ratio <= .33: # not many broken
		new_score = Scores.GOOD
	elif ratio >= .66: # many broken
		new_score = Scores.BAD
	return new_score
