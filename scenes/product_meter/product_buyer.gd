@tool
class_name ProductBuyer
extends Node

var _product: Product = null

func set_product(product: Product) -> void:
	_product = product

func can_unlock() -> bool:
	if not _product:
		return false

	return _can_afford(get_unlock_cost())

func can_buy(existing_amount: int) -> bool:
	if not _product:
		return false

	return _can_afford(get_cost(existing_amount))

func can_automate() -> bool:
	if not _product:
		return false

	return _can_afford(get_automate_cost())

func get_reward(existing_amount: int, mult: float) -> int:
	return ProductInfo.get_reward(_product, existing_amount, mult)

func get_cost(existing_amount: int) -> int:
	return ProductInfo.get_cost(_product, existing_amount)

func get_automate_cost() -> int:
	return ProductInfo.get_automate_cost(_product)

func get_unlock_cost() -> int:
	return ProductInfo.get_unlock_cost(_product)

func _can_afford(cost: int) -> bool:
	if Engine.is_editor_hint():
		return true

	return ScoreManager.can_afford(cost)
