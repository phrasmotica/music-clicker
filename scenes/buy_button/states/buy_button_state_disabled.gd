class_name BuyButtonStateDisabled
extends BuyButtonState

func _enter_tree() -> void:
	CustomLogger.debug("%s is now disabled" % _buy_button.name)

	_buy_button.disabled = true

func enable() -> void:
	transition_state(BuyButton.State.ENABLED)
