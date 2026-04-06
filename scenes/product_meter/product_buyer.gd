@tool
class_name ProductBuyer
extends Node

var _product: Product = null
var _amount := 0

func set_product(product: Product) -> void:
	_product = product

func set_amount(amount: int) -> void:
	_amount = amount

func get_amount() -> int:
	return _amount if _product else 0

func can_unlock() -> bool:
	if not _product:
		return false

	return _can_afford(get_unlock_cost())

func can_buy() -> bool:
	if not _product:
		return false

	return _can_afford(get_cost())

func can_automate() -> bool:
	if not _product:
		return false

	return _can_afford(get_automate_cost())

func get_reward(mult: float) -> int:
	return ProductInfo.get_reward(_product, _amount, mult)

func get_cost() -> int:
	return ProductInfo.get_cost(_product, _amount)

func get_automate_cost() -> int:
	return ProductInfo.get_automate_cost(_product)

func get_unlock_cost() -> int:
	return ProductInfo.get_unlock_cost(_product)

func _can_afford(cost: int) -> bool:
	if Engine.is_editor_hint():
		return true

	return ScoreManager.can_afford(cost)
