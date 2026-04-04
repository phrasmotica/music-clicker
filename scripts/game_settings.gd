@tool
class_name GameSettings
extends Node

signal starting_score_changed(starting_score: int)

@export
var starting_score: int = 0:
	set(value):
		starting_score = maxi(value, 0)

		if Engine.is_editor_hint():
			starting_score_changed.emit(starting_score)

@export
var score_manager: ScoreManager

func _ready() -> void:
	SignalHelper.once_next_frame(_emit_starting_score)

func _emit_starting_score() -> void:
	if score_manager:
		score_manager.set_starting_score(starting_score)

	GameEvents.emit_score_changed(starting_score)
