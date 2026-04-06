class_name BuyButtonStateDisabled
extends BuyButtonState

func _enter_tree() -> void:
	CustomLogger.debug("%s is now disabled" % _buy_button.name)
