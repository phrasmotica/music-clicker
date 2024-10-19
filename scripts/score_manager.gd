extends Node

var _score: int = 0

signal score_changed(score: int)

func _on_product_0_made_product(reward: int) -> void:
	_score += reward
	score_changed.emit(_score)
