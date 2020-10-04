extends Node


########################################
# PARAMS
########################################
var enemy_spawner_res: PackedScene = preload("res://src/EnemySpawner/EnemySpawner.tscn")
var old_spawners: Array = []


var current_wave: int = -1
var waves = [
	preload("res://src/Wave/Waves/wave1.tres"),
	preload("res://src/Wave/Waves/wave2.tres"),
	preload("res://src/Wave/Waves/wave3.tres"),
	preload("res://src/Wave/Waves/wave4.tres"),
	preload("res://src/Wave/Waves/wave5.tres")
]
var is_shaking: bool = false

var is_building: bool = false
var selected_building = null setget set_selected_building

var money: int = 7


func _ready() -> void:
	# connect signals
	Events.connect("game_lost", self, "_game_lost")
	Events.connect("game_won", self, "_game_won")
	
	Events.connect("wave_ended", self, "_end_wave")
	
	Events.connect("build_canceled", self, "_cancel_build")


func reset() -> void:
	old_spawners = []
	current_wave = -1
	is_building = false
	selected_building = null
	money = 7


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_clear_selection()
		Events.emit_signal("build_canceled")


func _end_wave() -> void:
	for s in old_spawners:
		s.end_life()
	old_spawners = []
	current_wave += 1
	if current_wave >= waves.size():
		Events.emit_signal("game_won")
		return
	_start_wave()


func _start_wave() -> void:
	# create new spawner
	var enemy_spawner = enemy_spawner_res.instance()
	old_spawners.append(enemy_spawner)
	get_tree().current_scene.add_child(enemy_spawner)
	# create wave object
	var d = waves[current_wave] as WaveTemplate
	Events.emit_signal("wave_loaded", d)
	# senf wave object to the enemy spawner
	enemy_spawner.load_wave_data(d)
	# move spawner to correct location
	enemy_spawner.move_to_location()
	# wait for timer
	Events.emit_signal("start_timer", d.wait_time)
	yield(Events, "timer_done")
	enemy_spawner.crash_land()
	yield(get_tree().create_timer(5.3), "timeout")
	# start spawning
	enemy_spawner.start_spawning()


func _game_won() -> void:
	get_tree().change_scene("res://src/VictoryScreen.tscn")


func _game_lost() -> void:
	get_tree().change_scene("res://src/LostScreen.tscn")


func _cancel_build() -> void:
	is_building = false


func _clear_selection() -> void:
	if selected_building != null:
			selected_building._deselect_building()
			selected_building = null


func set_selected_building(v) -> void:
	if v == selected_building:
		return
	_clear_selection()
	if v != null:
		selected_building = v


func add_money(value) -> void:
	money += value
	Events.emit_signal("money_changed")


func remove_money(value) -> void:
	add_money(-value)


func _shake_camera(strength: float) -> void:
	if is_shaking:
		# random vector
		var v = Vector2(randf(), randf()).normalized() * (randf() * strength + 0.1)
		# move camera offset
		var c = get_viewport().get_camera()
		if c == null:
			return
		c.h_offset = v.x
		c.v_offset = v.y * 0.3
		# yield time
		yield(get_tree().create_timer(0.05), "timeout")
		_shake_camera(strength)


func start_shake(time: float, strength: float) -> void:
	is_shaking = true
	_shake_camera(strength)
	yield(get_tree().create_timer(time), "timeout")
	stop_shake()


func stop_shake() -> void:
	is_shaking = false
	var c = get_viewport().get_camera()
	if c == null:
		return
	c.h_offset = 0
	c.v_offset = 0
