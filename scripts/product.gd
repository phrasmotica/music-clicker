@tool
class_name Product extends PanelContainer

@export_range(1.0, 10.0)
var base_time_seconds: float = 3.0

@export_range(1, 100)
var base_reward: int = 1

@export
var is_automated := false

@onready
var amount_label: Label = %AmountLabel

@onready
var make_button: Button = %MakeButton

@onready
var progress_bar: ProgressBar = %ProgressBar

@onready
var reward_label: Label = %RewardLabel

var _amount: int = 1:
	set(value):
		_amount = value

		if amount_label:
			amount_label.text = "x" + str(_amount)

		if reward_label:
			reward_label.text = "£" + str(_amount * base_reward)

var _is_making := false

signal bought_product(amount: int)
signal made_product(reward: int)

func _ready():
	reset_progress()

func _process(delta: float) -> void:
	if _is_making:
		progress_bar.value += 100 * delta / base_time_seconds

		if progress_bar.value >= 100:
			reset_progress()

			_is_making = false
			make_button.disabled = false

			made_product.emit(_amount * base_reward)

func buy() -> void:
	_amount += 1

	bought_product.emit(_amount)

func make() -> void:
	reset_progress()
	_is_making = true

func reset_progress() -> void:
	progress_bar.value = 0

func _on_buy_button_pressed() -> void:
	print("Buying a product...")

	buy()

func _on_make_button_pressed() -> void:
	print("Making a product...")

	make_button.disabled = true

	make()
