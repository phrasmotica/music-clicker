@tool
extends Node

@export
var amounts: Dictionary[int, int] = {}

signal bought_product(product: Product, cost: int)

func add_product(id: int, amount: int) -> int:
	if amounts.has(id):
		amounts[id] += amount
	else:
		amounts[id] = amount

	return amounts[id]

func _on_score_manager_product_bought(product: Product) -> void:
	var new_amount := add_product(product.id, 1)

	bought_product.emit(product, new_amount)
