@tool
extends Node

@onready
var score_label: Label = %ScoreLabel

func _on_score_manager_score_changed(score: int) -> void:
	if score_label:
		score_label.text = "£" + str(score)
