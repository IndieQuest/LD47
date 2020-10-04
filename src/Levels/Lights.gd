extends Spatial


var clockwise: bool


func _ready() -> void:
	Events.connect("change_blink_direction", self, "_change_blink_direction")
	_blink()


func _change_blink_direction(dir: float) -> void:
	clockwise = sign(dir) == -1


func _blink() -> void:
	var children = get_children()
	if not clockwise:
		children.invert()
	for c in children:
		c.get_node("Light").blink(0.18)
		yield(get_tree().create_timer(0.2), "timeout")
	_blink()
