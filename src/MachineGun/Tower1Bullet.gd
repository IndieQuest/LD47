extends "res://src/MachineGun/Bullet.gd"


export var damage: float = 0.5


func _on_Area_area_entered(area: Area) -> void:
	area.get_enemy().take_damage(damage)
	queue_free()
