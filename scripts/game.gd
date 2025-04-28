extends Node2D

func _ready() -> void:
	if not Engine.is_embedded_in_editor():
		_set_window()

func _set_window() -> void:
	var screen_size := DisplayServer.screen_get_size()
	var small_window_size := screen_size * 2 / 3

	# display at 16:9 regardless of screen's aspect ratio
	var small_window_height := small_window_size.x * 9.0 / 16
	small_window_size.y = int(small_window_height)

	var window := get_window()

	window.size = small_window_size
	window.move_to_center()
