extends Node


signal game_lost
signal game_won


signal enemy_hit
signal enemy_killed
signal base_hit

signal wave_started
signal wave_ended

signal build_requested(building_res, price)
signal build_canceled
signal building_error_occured

signal money_changed


signal wave_loaded(data)


signal start_timer(time)
signal timer_done(time)

signal force_start_wave


signal change_blink_direction(dir)


signal play_error
