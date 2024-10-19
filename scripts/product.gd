@tool
class_name Product extends PanelContainer

@export_range(1.0, 10.0)
var base_time_seconds := 3.0

@export
var is_automated := false

@onready
var make_button: Button = %MakeButton

@onready
var progress_bar: ProgressBar = %ProgressBar

var _is_making := false

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

			made_product.emit(1)

func make() -> void:
	reset_progress()
	_is_making = true

func reset_progress() -> void:
	progress_bar.value = 0

func _on_buy_button_pressed() -> void:
	print("Bought a product!")

func _on_make_button_pressed() -> void:
	print("Making a product...")

	make_button.disabled = true

	make()
