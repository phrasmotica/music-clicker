@tool
class_name ProductCounter
extends Resource

@export
var product: Product:
	set(value):
		product = value

		if product:
			SignalHelper.persist(product.changed, emit_changed)

		emit_changed()

@export
var amount: int = 0:
	set(value):
		amount = value

		emit_changed()

func add(count: int) -> int:
	amount += count
	return amount
