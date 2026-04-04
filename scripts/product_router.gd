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

func _handle_product_unlocked(product: Product) -> void:
	for c in products:
		if c.product == product:
			c.add(1)

			unlocked_product.emit(product, 1)

func _handle_product_bought(product: Product) -> void:
	for c in products:
		if c.product == product:
			c.add(1)
			bought_product.emit(product, c.amount, c.mult)
			return

func _emit_changed() -> void:
	products_changed.emit(products)
