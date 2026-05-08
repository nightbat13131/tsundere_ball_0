class_name TextureRect_Goal extends TextureRect

func _ready() -> void:
	set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT)
	

func apply_goal(goal: Goal_Info) -> void:
	set_texture(goal.get_goal_icon())
	goal.update_icon.connect(_on_update_icon)

func _on_update_icon(icon: Texture2D) -> void:
	set_texture(icon)
