extends Node

@onready
var score_label: Label = %ScoreLabel

func _on_score_manager_score_changed(score: int) -> void:
	score_label.text = "£" + str(score)
