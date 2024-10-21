@tool
class_name ProductMeter extends PanelContainer

@export
var product: Product:
	set(value):
		product = value

		update_name_label()
		update_reward_label()
		update_buy_button()

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

var _amount: int = 1:
	set(value):
		_amount = value

		update_amount_label()
		update_reward_label()

var _is_making := false

signal buy_product(product: Product)
signal made_product(reward: int)

func _ready():
	update_name_label()

	reset_progress()

func _process(delta: float) -> void:
	if _is_making:
		progress_bar.value += 100 * delta / product.base_time_seconds

		if progress_bar.value >= 100:
			reset_progress()

			_is_making = false
			make_button.disabled = false

			made_product.emit(_amount * product.base_reward)

func buy() -> void:
	buy_product.emit(product)

func make() -> void:
	reset_progress()
	_is_making = true

func reset_progress() -> void:
	progress_bar.value = 0

func update_name_label():
	if name_label:
		if product and product.product_name.length() > 0:
			name_label.text = product.product_name
		else:
			name_label.text = "<product_name>"

func update_amount_label():
	if amount_label:
		amount_label.text = "x" + str(_amount)

func update_reward_label():
	if reward_label:
		var r = product.base_reward if product and product.base_reward > 0 else 1
		reward_label.text = "£" + str(_amount * r)

func update_buy_button():
	if buy_button:
		var c = product.base_cost if product and product.base_cost > 0 else 1
		buy_button.text = "Buy £" + str(c)

func _on_buy_button_pressed() -> void:
	print("Buying a product...")

	buy()

func _on_make_button_pressed() -> void:
	print("Making a product...")

	make_button.disabled = true

	make()
