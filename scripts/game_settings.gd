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

func _ready() -> void:
	if not Engine.is_editor_hint():
		SignalHelper.once_next_frame(_emit_starting_score)

func _emit_starting_score() -> void:
	ScoreManager.set_starting_score(starting_score)
	GameEvents.emit_score_changed(starting_score)
