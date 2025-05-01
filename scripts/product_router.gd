@tool
class_name ProductRouter extends Node

@export
var amounts: Dictionary[int, int] = {}

@export_group("Dependencies")

@export
var score_manager: ScoreManager

signal bought_product(product: Product, amount: int, mult: float)

func _ready() -> void:
	if score_manager:
		score_manager.product_bought.connect(_handle_product_bought)

func add_product(id: int, amount: int) -> int:
	if amounts.has(id):
		amounts[id] += amount
	else:
		amounts[id] = amount

	return amounts[id]

func _handle_product_bought(product: Product) -> void:
	var new_amount := add_product(product.id, 1)

	# TODO: we should keep track of the product's current multiplier,
	# and only recompute it when necessary
	var mult := 1.0

	for k in product.multipliers.keys():
		var m := product.multipliers[k]

		if k <= new_amount:
			mult *= m
		else:
			break

	bought_product.emit(product, new_amount, mult)
