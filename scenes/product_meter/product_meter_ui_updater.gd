@tool
class_name ProductMeterUIUpdater extends Node

@export
var meter: ProductMeter

@export
var buyer: ProductBuyer

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
var unlock_button: Button

@export
var panel_style_box: StyleBoxFlat

var _local_panel_style_box: StyleBoxFlat

func _ready() -> void:
	if panel_style_box:
		_local_panel_style_box = panel_style_box.duplicate()

		meter.add_theme_stylebox_override("panel", _local_panel_style_box)

func lock() -> void:
	locked_container.show()
	unlocked_container.hide()

	if make_button:
		make_button.disabled = true

	if buy_button:
		buy_button.disabled = true

	if automate_button:
		automate_button.disabled = true

	if unlock_button:
		unlock_button.text = _get_unlock_text()
		unlock_button.disabled = not meter.can_unlock()

	update_labels()
	_reset_progress()

func unlock() -> void:
	locked_container.hide()
	unlocked_container.show()

	if _local_panel_style_box:
		if meter.product:
			_local_panel_style_box.bg_color = meter.product.colour
		else:
			_local_panel_style_box.bg_color = panel_style_box.bg_color

	if make_button:
		make_button.disabled = not meter.can_make()

	if buy_button:
		buy_button.text = _get_buy_text()
		buy_button.disabled = not meter.can_buy()

	if automate_button:
		automate_button.text = _get_automate_text()
		automate_button.disabled = not meter.can_automate()

	if unlock_button:
		unlock_button.disabled = true

func automate() -> void:
	locked_container.hide()
	unlocked_container.show()

	if _local_panel_style_box:
		if meter.product:
			_local_panel_style_box.bg_color = meter.product.colour
		else:
			_local_panel_style_box.bg_color = panel_style_box.bg_color

	if make_button:
		make_button.disabled = not meter.can_make()

	if buy_button:
		buy_button.text = _get_buy_text()
		buy_button.disabled = not meter.can_buy()

	if automate_button:
		automate_button.text = _get_automate_text()
		automate_button.disabled = true

	if unlock_button:
		unlock_button.disabled = true

func set_progress(progress: float) -> void:
	progress_bar.value = 100 * progress

func _reset_progress() -> void:
	progress_bar.value = 0.0

func highlight_reward() -> void:
	if reward_label:
		reward_label.do_highlight()

func update_background() -> void:
	if _local_panel_style_box:
		if meter.product and not meter.is_locked():
			_local_panel_style_box.bg_color = meter.product.colour
		else:
			_local_panel_style_box.bg_color = meter.locked_colour

func update_labels() -> void:
	if name_label:
		name_label.text = _get_name_text()

	if amount_label:
		amount_label.text = "x%d" % meter.get_amount()

	if reward_label:
		reward_label.text = "£%d" % buyer.get_reward(meter.get_amount(), meter.mult)

func update_buttons() -> void:
	if make_button:
		make_button.disabled = not meter.can_make()

	if buy_button:
		buy_button.text = _get_buy_text()
		buy_button.disabled = not meter.can_buy()

	if automate_button:
		automate_button.text = _get_automate_text()
		automate_button.disabled = not meter.can_automate()

	if unlock_button:
		unlock_button.text = _get_unlock_text()
		unlock_button.disabled = not meter.can_unlock()

func _get_name_text() -> String:
	if meter.product and meter.product.product_name.length() > 0:
		return meter.product.product_name

	return "<product_name>"

func _get_buy_text() -> String:
	return "Buy £%d" % buyer.get_cost(meter.get_amount())

func _get_automate_text() -> String:
	return "Automated!" if meter.is_automated() else "Automate £%d" % buyer.get_automate_cost()

func _get_unlock_text() -> String:
	return "Unlock £%d" % buyer.get_unlock_cost()
