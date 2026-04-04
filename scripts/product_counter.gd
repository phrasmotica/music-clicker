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

@export
var mult: float = 1.0:
	set(value):
		mult = value

		emit_changed()

func add(count: int) -> void:
	amount += count

	# TODO: we should keep track of the product's current multiplier,
	# and only recompute it when necessary
	var new_mult := 1.0

	for k in product.multipliers.keys():
		var m := product.multipliers[k]

		if k <= amount:
			new_mult *= m
		else:
			break

	mult = new_mult
