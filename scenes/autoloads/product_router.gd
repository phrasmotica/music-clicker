extends Node

var _products: Array[ProductCounter] = []

signal unlocked_product(product: Product, amount: int)
signal bought_product(product: Product, amount: int, mult: float)

func _ready() -> void:
	SignalHelper.persist(
		GameEvents.product_unlocked,
		_handle_product_unlocked)

	SignalHelper.persist(
		GameEvents.product_bought,
		_handle_product_bought)

func set_products(products: Array[ProductCounter]) -> void:
	_products = products

func _handle_product_unlocked(product: Product) -> void:
	for c in _products:
		if c.product == product:
			c.add(1)

			unlocked_product.emit(product, 1)

func _handle_product_bought(product: Product) -> void:
	for c in _products:
		if c.product == product:
			c.add(1)
			bought_product.emit(product, c.amount, c.mult)
			return
