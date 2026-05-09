class_name GoalTracker extends HBoxContainer

static var _instance : GoalTracker

static var score : Score

func _ready() -> void:
	_instance = self

func _clear_goals() -> void:
	for each_child in get_children():
		each_child.queue_free()

static func goal_check_in(goal: Goal_Info) -> void:
	score.add_goal(goal)
	#goals.append(goal)
	if _instance:
		var holder := TextureRect_Goal.new()
		var parent := CenterContainer.new()
		holder.apply_goal(goal)
		parent.add_child(holder)
		_instance.add_child(parent)

static func level_start() -> void:
	score = Score.new()# goals = []
	if _instance:
		_instance._clear_goals()



static func get_score() -> Score: return score
