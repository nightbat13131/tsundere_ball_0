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
		holder.request_reorder.connect(_instance._on_request_reorder)
		_instance._on_request_reorder()

static func level_start() -> void:
	score = Score.new()# goals = []
	if _instance:
		_instance._clear_goals()

static func get_score() -> Score: return score

func _on_request_reorder() -> void:
	var _child_count = get_child_count()
	if _child_count < 5: 
		return
	var j_child : TextureRect_Goal
	var jj_child : TextureRect_Goal
	var a = CenterContainer
	
	
	# I think this is buble sort
	for i in range(_child_count-1):
		for j in range(i, _child_count -1):
			a = get_child(j)
			j_child = a.get_child(0)# get_child(j).get_child(0)
			a = get_child(j+1)
			jj_child = a.get_child(0) # get_child(j+1).get_child(0)
			if jj_child.get_sort_order() < j_child.get_sort_order():
				move_child(get_child(j+1), j)
