@tool
class_name ProductRouter extends Node

# TODO: specify the initial list of products in GameSettings
@export
var products: Array[ProductCounter] = []:
	set(value):
		products = value

		for p in products:
			if p:
				SignalHelper.persist(p.changed, _emit_changed)

		_emit_changed()

signal products_changed(products: Array[ProductCounter])
signal unlocked_product(product: Product, amount: int)
signal bought_product(product: Product, amount: int, mult: float)

func _ready() -> void:
	if not Engine.is_editor_hint():
		SignalHelper.persist(
			GameEvents.product_unlocked,
			_handle_product_unlocked)

		SignalHelper.persist(
			GameEvents.product_bought,
			_handle_product_bought)

	_emit_changed()

func add_product(product: Product, amount: int) -> int:
	for c in products:
		if c.product == product:
			return c.add(amount)

	return 0

func _handle_product_unlocked(product: Product) -> void:
	for c in products:
		if c.product == product:
			c.add(1)

			unlocked_product.emit(product, 1)

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

func _emit_changed() -> void:
	products_changed.emit(products)
