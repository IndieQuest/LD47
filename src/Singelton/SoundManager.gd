extends Node


func play_error() -> void:
	$ErrorSound.stop()
	$ErrorSound.play()


func play_click() -> void:
	$ClickSound.stop()
	$ClickSound.play()
