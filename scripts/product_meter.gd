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
var is_automated := false

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
		ui_updater.buy_triggered.connect(buy)
		ui_updater.automate_triggered.connect(automate)

	_refresh()

	reset_progress()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if ui_updater:
		var did_make := ui_updater.increment(delta)

		if did_make:
			made_product.emit(get_reward())

func buy() -> void:
	if not product:
		return

	# BUG: buying a product while it's being made causes the Make button to
	# be re-enabled and the product to be un-automated
	var cost := get_cost()
	buy_product.emit(product, cost)

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

func automate() -> void:
	if not product:
		return

	automate_product.emit(product)

func reset_progress() -> void:
	if ui_updater:
		ui_updater.reset_progress()

func _refresh() -> void:
	if ui_updater:
		ui_updater.update()

func refresh_buttons(score: int) -> void:
	if ui_updater:
		ui_updater.update_buttons(score)

func set_automated() -> void:
	is_automated = true

	if ui_updater:
		ui_updater.set_automated()

func get_reward() -> int:
	if not product:
		return 0

	return int(mult * amount * maxi(product.base_reward, 1))
