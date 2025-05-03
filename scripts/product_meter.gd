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
		mult = maxf(value, 0.0)

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

var _is_making := false

signal buy_product(product: Product, cost: int)
signal made_product(reward: int)
signal automate_product(product: Product)

func _ready():
	_refresh()

	reset_progress()

func _process(delta: float) -> void:
	if product and (is_automated or _is_making):
		progress_bar.value += 100 * delta / product.base_time_seconds

	if progress_bar.value >= 100:
		reset_progress()

		_is_making = false

		if not is_automated:
			make_button.disabled = false

		made_product.emit(_get_reward())

func buy() -> void:
	if not product:
		return

	var cost := _get_cost()
	buy_product.emit(product, cost)

func _get_cost() -> int:
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

func _get_automate_cost() -> int:
	return product.automate_cost if product else 0

func make() -> void:
	if not product:
		return

	reset_progress()
	_is_making = true

func automate() -> void:
	if not product:
		return

	automate_product.emit(product)

func reset_progress() -> void:
	progress_bar.value = 0

func _refresh() -> void:
	if name_label:
		if product and product.product_name.length() > 0:
			name_label.text = product.product_name
		else:
			name_label.text = "<product_name>"

	if amount_label:
		amount_label.text = "x%d" % (amount if product else 0)

	if reward_label:
		reward_label.text = "£%d" % _get_reward()

	if make_button:
		make_button.disabled = product == null

	if buy_button:
		var c := _get_cost()
		buy_button.text = "Buy £%d" % c
		buy_button.disabled = product == null

	if automate_button:
		automate_button.text = "Automate £%d" % _get_automate_cost()
		automate_button.disabled = product == null

func refresh_buttons(score: int):
	if buy_button:
		buy_button.disabled = score < _get_cost()

	if automate_button:
		automate_button.disabled = is_automated or score < _get_automate_cost()

func set_automated() -> void:
	is_automated = true

	if make_button:
		make_button.disabled = true

	if automate_button:
		automate_button.disabled = true

func _get_reward() -> int:
	if not product:
		return 0

	return int(mult * amount * maxi(product.base_reward, 1))

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
