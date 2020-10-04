extends "res://src/Buildings/MoveableBuilding.gd"
class_name MainBase


########################################
# EXPORT PARAMS
########################################
export (int, 0, 100) var starting_health = 10


########################################
# PARAMS
########################################
onready var current_health: float  = starting_health


########################################
# OVERRIDE FUNCTIONS
########################################
func _ready() -> void:
	add_to_group("MainBase")


########################################
# API FUNCTIONS
########################################
func take_damage(damgae: float) -> void:
	current_health -= damgae
	GM.start_shake(0.3, 0.25)
	if current_health <= 0:
		$ExplotionSound.play()
		Events.emit_signal("game_lost")
	else:
		$HitSound.play()
		Events.emit_signal("base_hit")
	


########################################
# SENSORS
########################################
func _on_Sensor_body_entered(body: Node) -> void:
	pass # Replace with function body.





































