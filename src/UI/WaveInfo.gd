extends ColorRect


var wave_part_res = preload("res://src/UI/WavePart.tscn")
onready var layout = $Layout


func _ready() -> void:
	Events.connect("wave_loaded", self, "_show_wave")


func clear_preview() -> void:
	for c in layout.get_children():
		c.queue_free()



func _show_wave(data: WaveTemplate) -> void:
	clear_preview()
	for d in data.composition:
		var new_part = wave_part_res.instance()
		layout.add_child(new_part)
		new_part.populate(d[Globals.IDX], d[Globals.COUNT], d[Globals.DIRECTION])
