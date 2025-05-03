@tool
class_name ProductMeter extends PanelContainer

enum CurveType { LINEAR, LOGARITHMIC, EXPONENTIAL }

@export
var product: Product:
	set(value):
		product = value

		_refresh()

@export_range(1.0, 30.0)
var base_time_seconds: float = 3.0

@export
var cost_curve: CurveType

@export_range(100, 5000)
var automate_cost: int = 100:
	set(value):
		automate_cost = value

		_refresh()

@export
var is_automated := false

@onready
var name_label: Label = %NameLabel

@onready
var amount_label: Label = %AmountLabel

@onready
var make_button: Button = %MakeButton

@onready
var progress_bar: ProgressBar = %ProgressBar

@onready
var reward_label: Label = %RewardLabel

@onready
var buy_button: Button = %BuyButton

@onready
var automate_button: Button = %AutomateButton

# MEDIUM: turn these into exported properties with setters
var _amount: int = 1
var _mult: float = 1.0

var _is_making := false

signal buy_product(product: Product, cost: int)
signal made_product(reward: int)
signal automate_product(product: Product, automate_cost: int)

func _ready():
	_refresh()

	reset_progress()

func _process(delta: float) -> void:
	if is_automated or _is_making:
		progress_bar.value += 100 * delta / base_time_seconds

	if progress_bar.value >= 100:
		reset_progress()

		_is_making = false

		if not is_automated:
			make_button.disabled = false

		made_product.emit(_get_reward())

func buy() -> void:
	var cost := get_cost()
	buy_product.emit(product, cost)

func get_cost() -> int:
	if not product:
		return 1

	# https://www.desmos.com/calculator/w1vzpghz7i
	match cost_curve:
		CurveType.LINEAR:
			return int(product.base_cost * _amount)

		CurveType.LOGARITHMIC:
			return int(product.base_cost * pow(_amount, 0.7))

		CurveType.EXPONENTIAL:
			return int(product.base_cost * pow(_amount, 1.2))

	return int(product.base_cost * _amount)

func make() -> void:
	reset_progress()
	_is_making = true

func automate() -> void:
	automate_product.emit(product, automate_cost)

func reset_progress() -> void:
	progress_bar.value = 0

func set_amount_and_mult(amount: int, mult: float) -> void:
	_amount = amount
	_mult = mult

	print("%s amount=%d mult=%.1f" % [product.product_name, _amount, _mult])

	_refresh()

func _refresh() -> void:
	if name_label:
		if product and product.product_name.length() > 0:
			name_label.text = product.product_name
		else:
			name_label.text = "<product_name>"

	if amount_label:
		amount_label.text = "x%d" % _amount

	if reward_label:
		reward_label.text = "£%d" % _get_reward()

	if buy_button:
		var c := get_cost()
		buy_button.text = "Buy £%d" % c

	if automate_button:
		automate_button.text = "Automate £%d" % automate_cost

func refresh_buttons(score: int):
	if buy_button:
		buy_button.disabled = score < get_cost()

	if automate_button:
		automate_button.disabled = is_automated or score < automate_cost

func set_automated() -> void:
	is_automated = true

	if make_button:
		make_button.disabled = true

	if automate_button:
		automate_button.disabled = true

func _get_reward() -> int:
	if not product:
		return 0

	return int(_mult * _amount * maxi(product.base_reward, 1))

func _on_buy_button_pressed() -> void:
	print("Buying a product...")

	buy()

func _on_make_button_pressed() -> void:
	print("Making a product...")

	make_button.disabled = true

	make()

func _on_automate_button_pressed() -> void:
	if is_automated:
		return

	print("Automating " + product.product_name + "...")

	automate_button.disabled = true
	automate_button.text = "Automated!"

	automate()
