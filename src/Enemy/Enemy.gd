extends Spatial
class_name Enemy


########################################
# EXPORT PARAMS
########################################
export var speed: float = 1
export var health: float = 1
export var damage: float = 1
export var value: int = 1

########################################
# PARAMS
########################################
onready var current_health: float = health
onready var edge: Spatial = $Pivot/Edge
var is_moving: bool = false
var is_dead: bool = false


########################################
# OVERRIDE FUNCTIONS
########################################
func _ready() -> void:
	add_to_group("Enemies")


func _process(delta: float) -> void:
	if is_moving:
		rotate_y(delta * speed)


########################################
# API FUNCTIONS
########################################
func move_to_spawn_point(v: Vector3, t: float = 2) -> void:
	var start = edge.global_transform.origin
	t = start.distance_to(v) / abs(speed)
	$Tween.interpolate_property(edge, "translation", start, v, t, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$Pivot/Edge/Sensor/CollisionShape.disabled = false
	is_moving = true


func set_distance_from_center(v: float) -> void:
	edge.global_transform.origin.z = v


func attack(base: MainBase) -> void:
	if base != null:
		base.take_damage(damage)


func take_damage(damage: float) -> void:
	current_health -= damage
	Events.emit_signal("enemy_hit")
	print("Enemy <%s> took %.1f damage" % [name, damage])
	if current_health <= 0:
		die()


func die() -> void:
	if not is_dead:
		GM.add_money(value)
		Events.emit_signal("enemy_killed")
		queue_free()
		is_dead = true


########################################
# SENSOR
########################################
func _on_Sensor_area_entered(area: Area) -> void:
	if area.is_in_group("MainBaseSensor"):
		attack(area.get_base())


































