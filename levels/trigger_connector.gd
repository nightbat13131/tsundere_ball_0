@tool
class_name TriggerConnector extends Node2D

@export var trigger_trap : Trap
@export var effected_trap : Trap

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if trigger_trap and effected_trap:
		trigger_trap.used.connect(_on_trigger)
		

func _on_trigger(_thing: Ball, _trigger: Trap) -> void:
	print("triggered")
	if effected_trap:
		effected_trap.turn(45)

func _draw() -> void:
	if trigger_trap and effected_trap:
		draw_line(trigger_trap.position, effected_trap.position, Color.BLACK, 5)
