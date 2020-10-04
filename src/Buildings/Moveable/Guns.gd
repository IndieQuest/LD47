extends Spatial


func open_fire() -> void:
	for g in get_children():
		g.open_fire()
		yield(get_tree().create_timer(0.2), "timeout")


func cease_fire() -> void:
	for g in get_children():
		g.cease_fire()
