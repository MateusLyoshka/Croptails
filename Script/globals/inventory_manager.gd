extends Node

var inventory: Dictionary = Dictionary()

signal colected

func colect(collectable_name:String) -> void:
	inventory.get_or_add(collectable_name)
	if inventory[collectable_name] == null:
		inventory[collectable_name] = 1
	else:
		inventory[collectable_name] += 1
		
	colected.emit()
