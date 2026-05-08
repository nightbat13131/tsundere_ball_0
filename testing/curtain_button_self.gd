extends ButtonSelf


@export var _close := false

@export var thing: LoadingScreen

func _on_pressed() -> void:
	if !thing: 
		return
	if _close:
		thing.close_curtain()
	else:
		thing.open_curtain()
		
