extends Spatial



########################################
# EXPORT PARAMS
########################################



########################################
# PARAMS
########################################
onready var path = $Path
onready var curve = path.curve as Curve3D

var temp_tower
var current_res: PackedScene
var current_price: int
var is_building: bool = false


########################################
# OVERRIDE FUNCTIONS
########################################
func _ready() -> void:
	add_to_group("Level")
	Events.connect("build_requested", self, "_build_tower")
	Events.connect("build_canceled", self, "_cancel_build")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB") and is_building:
		_build()



func _process(delta: float) -> void:
	if is_building:
		# update the rotation based on the mouse
		_update_tower_rotation(temp_tower)


########################################
# API FUNCTIONS
########################################
func receive_enemy(enemy: PathFollow) -> void:
	enemy.get_parent().remove_child(enemy)
	path.add_child(enemy)


func get_spawn_point(v: Vector3) -> Vector3:
	v = to_local(v)
	return curve.get_closest_point(v)


func get_spawn_offset(v: Vector3) -> Vector3:
	v = to_local(v)
	return curve.get_closest_offset(v)


func _build_tower(res: PackedScene, price: int) -> void:
	current_res = res
	current_price = price
	if temp_tower != null:
		temp_tower.queue_free()
	temp_tower = res.instance()
	temp_tower.is_temp = true
	temp_tower.get_node("Edge/Graphics").scale = Vector3.ONE * 1.05
	add_child(temp_tower)
	is_building = true


func _cancel_build() -> void:
	if temp_tower != null:
		temp_tower.queue_free()
		temp_tower = null
		is_building = false


func _build() -> void:
	# actually place a working tower on the map
	if temp_tower.is_blocked():
		Events.emit_signal("building_error_occured")
		SoundManager.play_error()
		return
	var new_tower = current_res.instance()
	add_child(new_tower)
	# rotate to correct location
	_update_tower_rotation(new_tower)
	GM.remove_money(current_price)
	Events.emit_signal("build_canceled")
	$BuildSound.play()


########################################
# HELPER FUNCTIONS
########################################
func _update_tower_rotation(t) -> void:
	var pos = MouseHelper.get_plane_position()
	# calculate angle from center of map
	var angle = Vector3.FORWARD.angle_to(pos) * -sign(pos.x)
	t.rotation.y = angle



















































