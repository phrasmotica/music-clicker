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
var unlock_button: Button

@export
var panel_style_box: StyleBoxFlat

var _local_panel_style_box: StyleBoxFlat

var _is_making := false

signal unlock_triggered
signal buy_triggered
signal automate_triggered

func _ready() -> void:
	if make_button:
		SignalHelper.persist(
			make_button.pressed,
			_on_make_button_pressed
		)

	if buy_button:
		SignalHelper.persist(
			buy_button.pressed,
			_on_buy_button_pressed
		)

	if automate_button:
		SignalHelper.persist(
			automate_button.pressed,
			_on_automate_button_pressed
		)

	if unlock_button:
		SignalHelper.persist(
			unlock_button.pressed,
			_on_unlock_button_pressed
		)

	if panel_style_box:
		_local_panel_style_box = panel_style_box.duplicate()

		meter.add_theme_stylebox_override("panel", _local_panel_style_box)

func lock() -> void:
	locked_container.show()
	unlocked_container.hide()

	if _local_panel_style_box:
		_local_panel_style_box.bg_color = meter.locked_colour

	if make_button:
		make_button.disabled = true

	if buy_button:
		buy_button.disabled = true

	if automate_button:
		automate_button.disabled = true

	if unlock_button:
		unlock_button.text = _get_unlock_text()
		unlock_button.disabled = not _can_unlock()

	update()
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
		make_button.disabled = not _can_make()

	if buy_button:
		buy_button.text = _get_buy_text()
		buy_button.disabled = not _can_buy()

	if automate_button:
		automate_button.text = _get_automate_text()
		automate_button.disabled = not _can_automate()

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
		make_button.disabled = not _can_make()

	if buy_button:
		buy_button.text = _get_buy_text()
		buy_button.disabled = not _can_buy()

	if automate_button:
		automate_button.text = _get_automate_text()
		automate_button.disabled = true

	if unlock_button:
		unlock_button.disabled = true

func increment(delta: float) -> bool:
	if meter.product and (meter.is_automated() or _is_making):
		progress_bar.value += 100 * delta / meter.product.base_time_seconds

	if progress_bar.value >= 100:
		_reset_progress()

		_is_making = false

		if not meter.is_automated():
			make_button.disabled = false

		return true

	return false

func _reset_progress() -> void:
	progress_bar.value = 0

func highlight_reward() -> void:
	if reward_label:
		reward_label.do_highlight()

func update() -> void:
	# BUG: this causes an automated meter to revert to unlocked when a copy of
	# its product is bought. Maybe create a new signal specifically for when the
	# is_unlocked flag changes? Maybe we should generalise that to an enum
	# with locked/unlocked/automated...

	if name_label:
		name_label.text = _get_name_text()

	if amount_label:
		amount_label.text = "x%d" % meter.get_amount()

	if reward_label:
		reward_label.text = "£%d" % meter.get_reward()

func update_buttons() -> void:
	if buy_button:
		buy_button.text = _get_buy_text()
		buy_button.disabled = not _can_buy()

	if automate_button:
		automate_button.text = _get_automate_text()
		automate_button.disabled = not _can_automate()

	if unlock_button:
		unlock_button.text = _get_unlock_text()
		unlock_button.disabled = not _can_unlock()

func _get_name_text() -> String:
	if meter.product and meter.product.product_name.length() > 0:
		return meter.product.product_name

	return "<product_name>"

func _get_buy_text() -> String:
	return "Buy £%d" % meter.get_cost()

func _get_automate_text() -> String:
	return "Automated!" if meter.is_automated() else "Automate £%d" % meter.get_automate_cost()

func _get_unlock_text() -> String:
	return "Unlock £%d" % meter.get_unlock_cost()

func _can_make() -> bool:
	return meter.product != null and meter.is_unlocked() and not _is_making

func _can_buy() -> bool:
	return meter.product != null and not meter.is_locked() and _can_afford(meter.get_cost())

func _can_automate() -> bool:
	return meter.product != null and meter.is_unlocked() and _can_afford(meter.get_automate_cost())

func _can_unlock() -> bool:
	return meter.product != null and meter.is_locked() and _can_afford(meter.get_unlock_cost())

func _can_afford(cost: int) -> bool:
	if Engine.is_editor_hint():
		# TODO: maybe check against the starting score?
		return true

	return ScoreManager.can_afford(cost)

func _on_make_button_pressed() -> void:
	if _is_making:
		return

	print("Making a %s..." % meter.product.product_name)

	_is_making = true

	_reset_progress()
	update()

func _on_buy_button_pressed() -> void:
	print("Buying a %s..." % meter.product.product_name)

	buy_triggered.emit()

func _on_automate_button_pressed() -> void:
	if meter.is_automated():
		return

	print("Automating production of %s..." % meter.product.product_name)

	automate_triggered.emit()

func _on_unlock_button_pressed() -> void:
	if meter.is_unlocked():
		return

	print("Unlocking %s..." % meter.product.product_name)

	unlock_triggered.emit()
