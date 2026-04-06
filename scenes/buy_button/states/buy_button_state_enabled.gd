class_name BuyButtonStateEnabled
extends BuyButtonState

func _enter_tree() -> void:
	CustomLogger.debug("%s is now enabled" % _buy_button.name)

	_buy_button.disabled = false

	SignalHelper.persist(_buy_button.pressed, _handle_pressed)

func _handle_pressed() -> void:
	_buy_button.emit_buy_triggered()

func disable() -> void:
	transition_state(BuyButton.State.DISABLED)
