extends ButtonSelf

@export var node: Node2D

func _on_pressed() -> void:
	Level.pause()
