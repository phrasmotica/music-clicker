@tool
extends Node

@onready
var score_label: Label = %ScoreLabel

signal ui_ready

func _on_score_manager_score_changed(score: int) -> void:
	if score_label:
		score_label.text = "£" + str(score)

func _ready():
	if not Engine.is_editor_hint():
		var screen_size := DisplayServer.screen_get_size()
		var small_window_size := screen_size * 2 / 3

		# display at 16:9 regardless of screen's aspect ratio
		var small_window_height := small_window_size.x * 9.0 / 16
		small_window_size.y = int(small_window_height)

		var window := get_window()

		window.size = small_window_size
		window.move_to_center()

	ui_ready.emit()
