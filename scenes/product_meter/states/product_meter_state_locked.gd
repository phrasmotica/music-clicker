class_name ProductMeterStateLocked
extends ProductMeterState

func _enter_tree() -> void:
	CustomLogger.debug("%s is now locked" % _product_meter.name)

	_ui_updater.lock()

	SignalHelper.persist(
		_interaction.unlock_triggered,
		_handle_unlock_triggered)

func _handle_unlock_triggered() -> void:
	var product := _maker.get_product()

	if product:
		print("Unlocking %s..." % product.product_name)

		var cost := _buyer.get_unlock_cost()
		GameEvents.emit_unlock_product_requested(product, cost)

func unlock() -> void:
	transition_state(ProductMeter.State.UNLOCKED)

func is_locked() -> bool:
	return true

func can_unlock() -> bool:
	return _buyer.can_unlock()

func _can_afford(cost: int) -> bool:
	if Engine.is_editor_hint():
		return true

	return ScoreManager.can_afford(cost)
