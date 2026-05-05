class_name GoalTracker extends HBoxContainer

static var _instance : GoalTracker

static var goals : Array[Goal_Info]

func _ready() -> void:
	_instance = self

func _clear_goals() -> void:
	for each_child in get_children():
		each_child.queue_free()

static func goal_check_in(goal: Goal_Info) -> void:
	goals.append(goal)
	if _instance:
		var holder := TextureRect_Goal.new()
		holder.apply_goal(goal)
		_instance.add_child(holder)

static func level_start() -> void:
	goals = []
	if _instance:
		_instance._clear_goals()

static func level_end() -> float:

	return 1
