extends Control


func _on_DebugButton_pressed() -> void:
	Events.emit_signal("wave_ended")
