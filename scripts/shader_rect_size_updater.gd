@tool
class_name ShaderParamUpdater extends Node

@export
var target: Control

var _material: ShaderMaterial

func _ready() -> void:
	if not target:
		return

	_material = target.material as ShaderMaterial

	target.resized.connect(_handle_resized)

func update(param: StringName, value: Variant) -> void:
	if _material:
		_material.set_shader_parameter(param, value)

func _handle_resized() -> void:
	if _material and target:
		_material.set_shader_parameter("rect_size", target.size)
