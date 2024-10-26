extends Node

@export
var product_meters: Array[ProductMeter]

@export
var amounts: Dictionary = {}

func add_product(id: int, amount: int) -> void:
	if amounts.has(id):
		amounts[id] += amount
	else:
		amounts[id] = amount

func get_amount(id: int) -> int:
	return amounts.get(id, 0)

func _on_score_manager_product_bought(product: Product) -> void:
	add_product(product.id, 1)

	for pm in product_meters:
		var amount := get_amount(pm.product.id)
		pm.set_amount(amount)
