@tool
class_name ProductMeterUIUpdater extends Node

@export
var meter: ProductMeter

@export
var unlocked_container: Container

@export
var locked_container: Container

@export
var name_label: Label

@export
var amount_label: Label

@export
var make_button: Button

@export
var progress_bar: ProgressBar

@export
var reward_label: HighlightableText

@export
var buy_button: Button

@export
var automate_button: Button

@export
var panel_style_box: StyleBoxFlat

var _local_panel_style_box: StyleBoxFlat

var _is_making := false

signal buy_triggered
signal automate_triggered

func _ready() -> void:
	if panel_style_box:
		_local_panel_style_box = panel_style_box.duplicate()

		meter.add_theme_stylebox_override("panel", _local_panel_style_box)

func increment(delta: float) -> bool:
	if meter.product and (meter.is_automated or _is_making):
		progress_bar.value += 100 * delta / meter.product.base_time_seconds

	if progress_bar.value >= 100:
		reset_progress()

		_is_making = false

		if not meter.is_automated:
			make_button.disabled = false

		return true

	return false

func reset_progress() -> void:
	progress_bar.value = 0

func set_automated() -> void:
	if make_button:
		make_button.disabled = true

	if automate_button:
		automate_button.disabled = true

func disable_make_button() -> void:
	if make_button:
		make_button.disabled = true

func highlight_reward() -> void:
	if reward_label:
		reward_label.do_highlight()

func update() -> void:
	if unlocked_container:
		unlocked_container.visible = meter.is_unlocked

	if locked_container:
		locked_container.visible = not meter.is_unlocked

	if _local_panel_style_box:
		_local_panel_style_box.bg_color = _get_bg_colour()

	if name_label:
		if meter.product and meter.product.product_name.length() > 0:
			name_label.text = meter.product.product_name
		else:
			name_label.text = "<product_name>"

	if amount_label:
		amount_label.text = "x%d" % (meter.amount if meter.product else 0)

	if reward_label:
		reward_label.text = "£%d" % meter.get_reward()

	if make_button:
		make_button.disabled = meter.product == null

	if buy_button:
		var c := meter.get_cost()
		buy_button.text = "Buy £%d" % c
		buy_button.disabled = meter.product == null

	if automate_button:
		automate_button.text = "Automate £%d" % _get_automate_cost()
		automate_button.disabled = meter.product == null

func update_buttons(score: int) -> void:
	if buy_button:
		buy_button.disabled = score < meter.get_cost()

	if automate_button:
		automate_button.disabled = meter.is_automated or score < _get_automate_cost()

func _get_bg_colour() -> Color:
	if not meter.is_unlocked:
		return meter.locked_colour

	return meter.product.colour if meter.product else panel_style_box.bg_color

func _get_automate_cost() -> int:
	return meter.product.automate_cost if meter.product else 0

func _on_make_button_pressed() -> void:
	print("Making a product...")

	if make_button:
		make_button.disabled = true

	reset_progress()
	_is_making = true

func _on_buy_button_pressed() -> void:
	print("Buying a product...")

	buy_triggered.emit()

func _on_automate_button_pressed() -> void:
	if meter.is_automated:
		return

	print("Automating " + meter.product.product_name + "...")

	if automate_button:
		automate_button.disabled = true
		automate_button.text = "Automated!"

	automate_triggered.emit()
