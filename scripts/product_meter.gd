@tool
class_name ProductMeter extends PanelContainer

@export
var product: Product:
	set(value):
		product = value

		if product and not product.changed.is_connected(_refresh):
			product.changed.connect(_refresh)

		_refresh()

@export
var amount: int = 1:
	set(value):
		amount = maxi(value, 0)

		_refresh()

@export
var mult: float = 1.0:
	set(value):
		var old := mult
		var new := maxf(value, 0.0)

		mult = maxf(value, 0.0)

		_refresh()

		if not Engine.is_editor_hint() and old != new and ui_updater:
			ui_updater.highlight_reward()

@export
var is_unlocked := false:
	set(value):
		is_unlocked = value

		_refresh()

@export
var is_automated := false:
	set(value):
		is_automated = value

		_refresh()

@export
var locked_colour: Color:
	set(value):
		locked_colour = value

		_refresh()

@onready
var ui_updater: ProductMeterUIUpdater = %UIUpdater

signal buy_product(product: Product, cost: int)
signal made_product(reward: int)
signal automate_product(product: Product)

func _ready() -> void:
	if ui_updater:
		ui_updater.buy_triggered.connect(_buy)
		ui_updater.automate_triggered.connect(_automate)

	_refresh()

	reset_progress()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if ui_updater:
		var did_make := ui_updater.increment(delta)

		if did_make:
			made_product.emit(get_reward())

func _buy() -> void:
	if not product:
		return

	var cost := get_cost()
	buy_product.emit(product, cost)

func _automate() -> void:
	if not product:
		return

	automate_product.emit(product)

func get_amount() -> int:
	return amount if product else 0

func get_reward() -> int:
	if not product:
		return 0

	return int(mult * amount * maxi(product.base_reward, 1))

func get_cost() -> int:
	if not product:
		return 0

	# https://www.desmos.com/calculator/w1vzpghz7i
	match product.cost_curve:
		Product.CurveType.LINEAR:
			return int(product.base_cost * amount)

		Product.CurveType.LOGARITHMIC:
			return int(product.base_cost * pow(amount, 0.7))

		Product.CurveType.EXPONENTIAL:
			return int(product.base_cost * pow(amount, 1.2))

	return int(product.base_cost * amount)

func get_automate_cost() -> int:
	return product.automate_cost if product else 0

func reset_progress() -> void:
	if ui_updater:
		ui_updater.reset_progress()

func _refresh() -> void:
	if ui_updater:
		ui_updater.update()

func update_score(score: int) -> void:
	if ui_updater:
		ui_updater.update_score(score)
