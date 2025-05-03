@tool
class_name ProductRouter extends Node

@export
var products: Array[Product] = []:
	set(value):
		products = value

		products_changed.emit(products)

@export
var amounts: Dictionary[Product, int] = {}

@export_group("Dependencies")

@export
var score_manager: ScoreManager

signal products_changed(products: Array[Product])
signal bought_product(product: Product, amount: int, mult: float)

func _ready() -> void:
	if score_manager:
		score_manager.product_bought.connect(_handle_product_bought)

	products_changed.emit(products)

func add_product(product: Product, amount: int) -> int:
	if amounts.has(product):
		amounts[product] += amount
	else:
		amounts[product] = amount

	return amounts[product]

func _handle_product_bought(product: Product) -> void:
	var new_amount := add_product(product, 1)

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
