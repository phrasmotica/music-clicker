class_name ProductMeterStateAutomated
extends ProductMeterState

func _enter_tree() -> void:
	CustomLogger.debug("%s is now automated" % _product_meter.name)

	_ui_updater.unlock()

	SignalHelper.persist(
		_ui_updater.buy_triggered,
		_handle_buy_triggered)

func _process(delta: float) -> void:
	var did_make := _ui_updater.increment(delta)

	if did_make:
		GameEvents.emit_product_made(_product_meter.get_reward())

func _handle_buy_triggered() -> void:
	if _product_meter.product:
		GameEvents.emit_buy_product_requested(_product_meter.product, _product_meter.get_cost())

func is_automated() -> bool:
	return true
