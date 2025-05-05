@tool
class_name ShaderProgressor extends Node

@export
var target: Control

@export
var duration: float = 1.0

var _material: ShaderMaterial

var _remaining: float = 0

signal progress_finished

func _ready() -> void:
	if not target:
		return

	_material = target.material as ShaderMaterial

func _process(delta: float) -> void:
	if _remaining > 0:
		_remaining -= (delta / duration)

		_material.set_shader_parameter("progress", 1 - _remaining)

		if _remaining <= 0:
			progress_finished.emit()

func trigger() -> void:
	_remaining = 1
