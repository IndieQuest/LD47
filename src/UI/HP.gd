extends HBoxContainer


onready var base = get_tree().get_nodes_in_group("MainBase")[0]


func _ready() -> void:
	Events.connect("base_hit", self, "_update_health")
	$value.text = str(base.current_health)

func _update_health() -> void:
	$value.text = str(base.current_health)
