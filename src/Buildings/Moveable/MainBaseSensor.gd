extends Area


onready var base = get_node("../..")


func get_base() -> MainBase:
	return base
