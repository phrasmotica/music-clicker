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
var _current_score := 0

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
		name_label.text = _get_name_text()

	if amount_label:
		amount_label.text = _get_amount_text()

	if reward_label:
		reward_label.text = _get_reward_text()

	if make_button:
		make_button.disabled = not _can_make()

	if buy_button:
		buy_button.text = _get_buy_text()
		buy_button.disabled = not _can_buy()

	if automate_button:
		automate_button.text = _get_automate_text()
		automate_button.disabled = not _can_automate()

func update_score(score: int) -> void:
	_current_score = score

	update()

func _get_bg_colour() -> Color:
	if not meter.is_unlocked:
		return meter.locked_colour

	return meter.product.colour if meter.product else panel_style_box.bg_color

func _get_name_text() -> String:
	if meter.product and meter.product.product_name.length() > 0:
		return meter.product.product_name

	return "<product_name>"

func _get_amount_text() -> String:
	return "x%d" % meter.get_amount()

func _get_reward_text() -> String:
	return "£%d" % meter.get_reward()

func _get_buy_text() -> String:
	return "Buy £%d" % meter.get_cost()

func _get_automate_text() -> String:
	return "Automated!" if meter.is_automated else "Automate £%d" % meter.get_automate_cost()

func _can_make() -> bool:
	return meter.product != null and not (_is_making or meter.is_automated)

func _can_buy() -> bool:
	return meter.product != null and _current_score >= meter.get_cost()

func _can_automate() -> bool:
	return meter.product != null and _current_score >= meter.get_automate_cost() and not meter.is_automated

func _on_make_button_pressed() -> void:
	if _is_making:
		return

	print("Making a %s..." % meter.product.product_name)

	_is_making = true

	reset_progress()
	update()

func _on_buy_button_pressed() -> void:
	print("Buying a %s..." % meter.product.product_name)

	buy_triggered.emit()

func _on_automate_button_pressed() -> void:
	if meter.is_automated:
		return

	print("Automating production of %s..." % meter.product.product_name)

	automate_triggered.emit()
