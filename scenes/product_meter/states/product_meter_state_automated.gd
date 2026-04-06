class_name ProductMeterStateAutomated
extends ProductMeterState

func _enter_tree() -> void:
	CustomLogger.debug("%s is now automated" % _product_meter.name)

	_ui_updater.unlock()

	SignalHelper.persist(
		_interaction.buy_triggered,
		_handle_buy_triggered)

func _process(delta: float) -> void:
	var did_make := _maker.increment(delta)

	_ui_updater.set_progress(_maker.get_progress())

	if did_make:
		GameEvents.emit_product_made(_product_meter.get_reward())

func _handle_buy_triggered() -> void:
	var product = _maker.get_product()

	if product:
		print("Buying a %s..." % product.product_name)

		GameEvents.emit_buy_product_requested(product, _product_meter.get_cost())

func is_making() -> bool:
	return true

func is_automated() -> bool:
	return true

func can_buy() -> bool:
	return _product_meter.product != null and _can_afford(_product_meter.get_cost())

func _can_afford(cost: int) -> bool:
	if Engine.is_editor_hint():
		return true

	return ScoreManager.can_afford(cost)
