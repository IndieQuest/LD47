extends Spatial
class_name EnemySpawner


########################################
# EXPORT PARAMS
########################################
export (Array, PackedScene) var enemy_resources = []


########################################
# PARAMS
########################################

onready var starting_point = $Graphics/StartingPoint
onready var spawn_point = $Graphics/SpawnPoint
onready var timer = $Timer
var data: WaveTemplate
var num_in_wave: int

########################################
# OVERRIDE FUNCTIONS
########################################
func _ready() -> void:
	add_to_group("EnemySpawner")
	Events.connect("enemy_killed", self, "_creep_killed")


########################################
# API FUNCTIONS
########################################
func load_wave_data(data: WaveTemplate) -> void:
	self.data = data
	for d in data.composition:
		num_in_wave += d[Globals.COUNT]


func move_to_location() -> void:
	# rotate
	rotation_degrees.y = data.angle


func start_spawning() -> void:
	for d in data.composition:
		var idx = d[Globals.IDX]
		var count = d[Globals.COUNT]
		var id = d[Globals.ID]
		var od = d[Globals.OD]
		var dir = d[Globals.DIRECTION]
		for i in range(count):
			_spawn_enemy(idx, dir)
			timer.start(id)
			yield(timer, "timeout")
		Events.emit_signal("change_blink_direction", dir)
		timer.start(od)
		yield(timer, "timeout")
	$AnimationPlayer.play_backwards("Spawn")
	$LandingStrip.hide()


func end_life() -> void:
	queue_free()


func crash_land() -> void:
	$AnimationPlayer.play("Spawn")


func _end_land() -> void:
	$Graphics/StartingPoint/MeshInstance/Jet.emitting = false


########################################
# HELPER FUNCTIONS
########################################
func _spawn_enemy(idx: int, dir: int) -> void:
	if idx >= enemy_resources.size() or idx < 0:
		print("IDX out of bounds for enemy resource type")
		get_tree().quit()
	var new_enemy = enemy_resources[idx].instance() as Enemy
	new_enemy.speed *= sign(dir)
	var start = starting_point.transform.origin
	var end = spawn_point.transform.origin
	new_enemy.hide()
	add_child(new_enemy)
#	new_enemy.rotation_degrees.y = data.angle
	new_enemy.set_distance_from_center(start.z)
	new_enemy.show()
	new_enemy.move_to_spawn_point(end)


func _creep_killed() -> void:
	num_in_wave -= 1
	if num_in_wave == 0:
		Events.emit_signal("wave_ended")











































