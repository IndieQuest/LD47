extends VBoxContainer


onready var timer = $Timer
onready var value = $Value


func _ready() -> void:
	Events.connect("start_timer", self, "start_timer")
	Events.connect("force_start_wave", self, "finish_timer")
	timer.connect("timeout", self, "finish_timer")


func _process(delta: float) -> void:
	value.text = str(int(timer.time_left) + 1)


func start_timer(v: float) -> void:
	get_parent().show()
	timer.start(v)


func finish_timer() -> void:
	get_parent().hide()
	timer.stop()
	Events.emit_signal("timer_done")
