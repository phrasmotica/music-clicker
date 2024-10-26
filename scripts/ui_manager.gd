extends Node

@onready
var score_label: Label = %ScoreLabel

func _on_score_manager_score_changed(score: int) -> void:
	score_label.text = "£" + str(score)

func _ready():
	var screen_size := DisplayServer.screen_get_size()
	var small_window_size := screen_size * 2 / 3

	var window := get_window()

	window.size = small_window_size
	window.move_to_center()
