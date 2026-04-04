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
var is_unlocked := false:
	set(value):
		is_unlocked = value

		emit_changed()

@export
var amount: int = 0:
	set(value):
		amount = maxi(value, 0)

		emit_changed()

@export
var mult: float = 1.0:
	set(value):
		mult = maxf(value, 1.0)

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

func unlock() -> void:
	is_unlocked = true
