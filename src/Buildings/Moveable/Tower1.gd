extends "res://src/Buildings/Tower.gd"


onready var turret = $Edge/Graphics/Head
onready var guns = $Edge/Graphics/Head/Guns
var is_firing: bool = false


func remove_from_enemies_in_range(enemy: Enemy) -> void:
	.remove_from_enemies_in_range(enemy)
	if enemies_in_range.size() == 0:
		turret.target = null
		turret.active = false
		is_firing = false
		guns.cease_fire()

func _process(delta: float) -> void:
	._process(delta)
	var target = _get_target()
	if is_temp:
		return
	if target != null:
		turret.target = target.get_node("Pivot/Edge")
		turret.active = true
		if not is_firing:
			is_firing = true
			guns.open_fire()
	else:
		turret.target = null
		turret.active = false
		is_firing = false
		guns.cease_fire()
