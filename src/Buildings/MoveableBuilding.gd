extends Spatial
class_name MoveableBuilding


########################################
# EXPORT PARAMS
########################################
export var speed: float = 1


########################################
# PARAMS
########################################
onready var edge = $Edge
var is_selected: bool = false


########################################
# API FUNCTIONS
########################################
func _process(delta: float) -> void:
	if is_selected:
		if Input.is_action_pressed("building_move_clockwise"):
			rotate_clockwise(delta)
		if Input.is_action_pressed("building_move_counter_clockwise"):
			rotate_counter_clockwise(delta)


########################################
# API FUNCTIONS
########################################
func set_location(angle: float, distance: float) -> void:
	rotation_degrees.y = angle
	edge.translation.z = distance


func rotate_clockwise(delta: float) -> void:
	rotate_y(-delta * speed)


func rotate_counter_clockwise(delta: float) -> void:
	rotate_y(delta * speed)


########################################
# HELPER FUNCTIONS
########################################
func _on_Sensor_input_event(camera: Node, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("LMB") and not GM.is_building and not is_selected:
		_select_building()


func _select_building() -> void:
	is_selected = true
	GM.selected_building = self
	$Edge/HoverIcon.show()
	SoundManager.play_click()


func _deselect_building() -> void:
	is_selected = false
	$Edge/HoverIcon.hide()
