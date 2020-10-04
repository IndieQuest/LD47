extends HBoxContainer


func _ready() -> void:
	Events.connect("money_changed", self, "_update_money")
	$value.text = str(GM.money)


func _update_money() -> void:
	$value.text = str(GM.money)
