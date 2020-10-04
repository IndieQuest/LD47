extends MeshInstance


func flash() -> void:
	for i in range(3):
		show()
		yield(get_tree().create_timer(0.03), "timeout")
		hide()
