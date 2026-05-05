extends TextureButton_Enhanced

func _on_pressed() -> void:
	LevelSelect.request_activate()
	GameLevelUI.request_deactivate()
