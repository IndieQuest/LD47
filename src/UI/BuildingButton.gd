extends Button


########################################
# EXPORT PARAMS
########################################
export var building_res: PackedScene = preload("res://src/Buildings/Moveable/DebugTower.tscn")
export var price: int = 1
export var active_color: Color
export var disabled_color: Color

export var text_active_color: Color = Color.white
export var text_disabled_color: Color = Color(0.2, 0.2, 0.2, 0.7)

export var price_active_color: Color = Color.white
export var price_disabled_color: Color = Color(0.2, 0.2, 0.2, 0.7)

onready var bg = $BG
onready var title = $Title
onready var price_labels = $Price


func _ready() -> void:
	$Price/Value.text = str(price)
	_update_status()
	Events.connect("money_changed", self, "_update_status")


func _on_BuildingButton_pressed() -> void:
	GM.is_building = true
	Events.emit_signal("build_requested", building_res, price)
	SoundManager.play_click()


func _update_status() -> void:
	disabled = GM.money < price
	bg.color = disabled_color if disabled else active_color
	var new_color = text_disabled_color if disabled else text_active_color
	title.add_color_override("font_color", new_color)
	new_color = price_disabled_color if disabled else price_active_color
	for l in price_labels.get_children():
		l.add_color_override("font_color", new_color)
