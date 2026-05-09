class_name Score extends Resource

## If I add scores, I need to adjust the LevelInfo unlock check
enum Scores {LOCKED = -1, NA = 0, FULL_FAIL = 1, BAD = 2, MID = 3, GOOD = 4, FULL_WIN = 5}

var _goals : Array[Goal_Info]

func add_goal(goal: Goal_Info) -> void:
	if !_goals.has(goal):
		_goals.append(goal)

func get_total() -> int: return _goals.size()

func get_failed() -> int:
	var count := 0
	for each_goal in _goals:
		if each_goal.is_failed():
			count += 1
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

static func ratio_to_score(broken: int, total: int) -> Scores:
	var new_score := Scores.MID
	var ratio : float = broken / float(total)
	if broken == 0:
		new_score = Scores.FULL_WIN
	elif broken >= total:
		new_score = Scores.FULL_FAIL
	elif ratio <= .33: # not many broken
		new_score = Scores.GOOD
	elif ratio >= .66: # many broken
		new_score = Scores.BAD
	return new_score
