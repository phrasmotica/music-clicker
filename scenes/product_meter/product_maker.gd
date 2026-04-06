class_name ProductMaker
extends Node

var _product: Product = null
var _is_making := false
var _progress := 0.0

func get_product() -> Product:
	return _product

func set_product(product: Product) -> void:
	_product = product

func get_reward(existing_amount: int, mult: float) -> int:
	if not _product:
		return 0

	return int(mult * existing_amount * maxi(_product.base_reward, 1))

func get_cost(existing_amount: int) -> int:
	if not _product:
		return 0

	# https://www.desmos.com/calculator/w1vzpghz7i
	match _product.cost_curve:
		Product.CurveType.LINEAR:
			return int(_product.base_cost * existing_amount)

		Product.CurveType.LOGARITHMIC:
			return int(_product.base_cost * pow(existing_amount, 0.7))

		Product.CurveType.EXPONENTIAL:
			return int(_product.base_cost * pow(existing_amount, 1.2))

	return int(_product.base_cost * existing_amount)

func get_automate_cost() -> int:
	return _product.automate_cost if _product else 0

func get_unlock_cost() -> int:
	return _product.unlock_cost if _product else 0

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
