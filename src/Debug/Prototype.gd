extends Spatial


func _ready() -> void:
	GM.reset()
	Events.emit_signal("wave_ended")
