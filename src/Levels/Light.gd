extends MeshInstance

onready var light = $OmniLight

func blink(time: float) -> void:
	light.show()
	yield(get_tree().create_timer(time), "timeout")
	light.hide()
