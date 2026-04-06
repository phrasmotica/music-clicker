class_name ProductMeterStateUnlocked
extends ProductMeterState

var _should_make := false

func _enter_tree() -> void:
	CustomLogger.debug("%s is now unlocked" % _product_meter.name)

	_ui_updater.unlock()

	SignalHelper.persist(
		_interaction.make_triggered,
		_handle_should_make)

	SignalHelper.persist(
		_interaction.buy_triggered,
		_handle_buy_triggered)

	SignalHelper.persist(
		_interaction.automate_triggered,
		_handle_automate_triggered)

func _process(delta: float) -> void:
	if _should_make:
		var did_make := _maker.increment(delta)

		_ui_updater.set_progress(_maker.get_progress())

		if did_make:
			GameEvents.emit_product_made(_buyer.get_reward())

			_should_make = false
			_ui_updater.update_buttons()

func _handle_should_make() -> void:
	if not _should_make:
		_should_make = true
		_ui_updater.update_buttons()

func _handle_buy_triggered(amount: int) -> void:
	var product = _maker.get_product()

	if product:
		print("Buying %d of %s..." % [amount, product.product_name])

		var cost := _buyer.get_cost()
		GameEvents.emit_buy_product_requested(product, cost)

func _handle_automate_triggered() -> void:
	var product = _maker.get_product()

	if product:
		print("Automating production of %s..." % product.product_name)

		GameEvents.emit_automate_product_requested(product)

func automate() -> void:
	transition_state(ProductMeter.State.AUTOMATED)

func can_make() -> bool:
	return _maker.get_product() != null and not _should_make

func can_buy() -> bool:
	return _buyer.can_buy()

func can_automate() -> bool:
	return _buyer.can_automate()

func _can_afford(cost: int) -> bool:
	if Engine.is_editor_hint():
		return true

	return ScoreManager.can_afford(cost)
