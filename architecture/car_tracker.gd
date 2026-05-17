class_name CarTracker extends Node2D
## the trap and door tracking for this node it techincal debit.

signal done

var _cars : Array[Breakable_Car] = []

func _ready() -> void:
	for each_child in get_children():
		if each_child is Breakable_Car:
			if !_cars.has(each_child):
				_cars.append(each_child)
				each_child.used.connect(_on_car_used)
				print(_cars.size())

func _on_car_used(car: Breakable_Car) -> void:
	_cars.erase(car)
	print(_cars.size())
	if _cars.is_empty():
		done.emit()
