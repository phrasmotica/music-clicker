class_name ProductMaker
extends Node

var _product: Product = null
var _is_making := false
var _progress := 0.0

func get_product() -> Product:
	return _product

func set_product(product: Product) -> void:
	_product = product

func is_making() -> bool:
	return _is_making

func increment(delta: float) -> bool:
	if not _product:
		return false

	if not _is_making:
		_is_making = true

	_progress += delta / _product.base_time_seconds

	if _progress >= 1.0:
		_progress = 0.0
		_is_making = false

		return true

	return false

func get_progress() -> float:
	return _progress
