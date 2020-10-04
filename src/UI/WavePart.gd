extends ColorRect

onready var name_l = $Info/Name
onready var amount_l = $Info/Amount
onready var direction_l = $Info/Direction


func populate(idx: int, amount: int, dir: float) -> void:
	name_l.text = Globals.enemy_names[idx]
	amount_l.text = str(amount)
	direction_l.text = "Clockwise" if sign(dir) == -1 else "Counter clockwise"
