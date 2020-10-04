extends Button


func _on_NextWaveButton_pressed() -> void:
	Events.emit_signal("force_start_wave")
