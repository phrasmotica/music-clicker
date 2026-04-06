class_name ProductMeterStateLocked
extends ProductMeterState

func _enter_tree() -> void:
	CustomLogger.debug("%s is now locked" % _product_meter.name)

	_ui_updater.lock()

	SignalHelper.persist(
		_ui_updater.unlock_triggered,
		_handle_unlock_triggered)

func _handle_unlock_triggered() -> void:
	if _product_meter.product:
		GameEvents.emit_unlock_product_requested(_product_meter.product, _product_meter.get_unlock_cost())

func unlock() -> void:
	transition_state(ProductMeter.State.UNLOCKED)

func is_locked() -> bool:
	return true
