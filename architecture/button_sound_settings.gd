extends TextureButton_Enhanced

func _on_pressed() -> void:
	SoundManager.toggle_audio_settings()
