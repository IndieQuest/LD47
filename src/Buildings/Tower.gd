extends "res://src/Buildings/MoveableBuilding.gd"

########################################
# EXPORT PARAMS
########################################
export var damage: float = 1
export var cooldown: float = 1
export var regular_material: SpatialMaterial
export var blocked_material: SpatialMaterial
export var free_material: SpatialMaterial

########################################
# PARAMS
########################################
var enemies_in_range: Array = []
onready var timer = $Timer
onready var clockwise_blocker = $Edge/MovementBlocker/BlockClockwise
onready var counter_blocker = $Edge/MovementBlocker/BlockCounterClockwise
var is_temp: bool = false
onready var building_blocker = $Edge/BuildingBlocker


########################################
# OVERRIDE FUNCTIONS
########################################
func _ready() -> void:
	timer.connect("timeout", self, "attack")
	reset_material()


func _process(delta: float) -> void:
	if is_temp:
		if is_blocked():
			mark_as_blocked()
		else:
			mark_as_free()

########################################
# API FUNCTIONS
########################################
func rotate_clockwise(delta: float) -> void:
	# test if not blocked
	if clockwise_blocker.get_overlapping_areas().size() > 0:
		return
	.rotate_clockwise(delta)


func rotate_counter_clockwise(delta: float) -> void:
	if counter_blocker.get_overlapping_areas().size() > 0:
		return
	.rotate_counter_clockwise(delta)


func attack() -> void:
	pass


func add_to_enemies_in_range(enemy: Enemy) -> void:
	if not enemy in enemies_in_range:
		enemies_in_range.append(enemy)
	if not timer.time_left:
		attack()


func remove_from_enemies_in_range(enemy: Enemy) -> void:
	if enemy in enemies_in_range:
		enemies_in_range.erase(enemy)


func _on_Range_area_entered(area: Area) -> void:
	if area.is_in_group("EnemySensor"):
		add_to_enemies_in_range(area.get_enemy())


func _on_Range_area_exited(area: Area) -> void:
	if area.is_in_group("EnemySensor"):
		remove_from_enemies_in_range(area.get_enemy())


func reset_material() -> void:
	_change_mat(regular_material)


func mark_as_blocked() -> void:
	_change_mat(blocked_material)


func mark_as_free() -> void:
	_change_mat(free_material)


func is_blocked() -> bool:
	return building_blocker.get_overlapping_areas().size()


########################################
# HELPER FUNCTIONS
########################################
func _get_target():
	if enemies_in_range.size() == 0:
		return
	return enemies_in_range[0]


func _change_mat(mat: SpatialMaterial) -> void:
	for m in $Edge/Graphics.get_children():
		for i in range(m.get_surface_material_count()):
			m.set_surface_material(i, mat)




















