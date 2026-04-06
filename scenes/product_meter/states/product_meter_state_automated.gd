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
		var reward := _buyer.get_reward(_product_meter.mult)
		GameEvents.emit_product_made(reward)

func _handle_buy_triggered() -> void:
	var product = _maker.get_product()

	if product:
		print("Buying a %s..." % product.product_name)

		var cost := _buyer.get_cost()
		GameEvents.emit_buy_product_requested(product, cost)

func is_automated() -> bool:
	return true

func can_buy() -> bool:
	return _buyer.can_buy()

func _can_afford(cost: int) -> bool:
	if Engine.is_editor_hint():
		return true

	return ScoreManager.can_afford(cost)
