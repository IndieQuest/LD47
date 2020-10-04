extends "res://src/Enemy/Enemy.gd"


func attack(base: MainBase) -> void:
	.attack(base)
	var target = base.get_node("Edge").global_transform.origin
	_explode(target)


func _explode(pos: Vector3) -> void:
	$Pivot/Edge/Explotion.global_transform.origin = pos + Vector3.UP * 0.25
	for p in $Pivot/Edge/Explotion.get_children():
		p.emitting = true


func die() -> void:
	$Pivot/Edge/Explotion.global_transform.origin = edge.global_transform.origin
	$Pivot/Edge/Graphics.hide()
	$Pivot/Edge/OmniLight.hide()
	$Pivot/Edge/Sensor/CollisionShape.disabled = true
	for p in $Pivot/Edge/Explotion.get_children():
		p.emitting = true
	$Pivot/Edge/DeathSound.play()
	yield(get_tree().create_timer(2.5), "timeout")
	.die()
