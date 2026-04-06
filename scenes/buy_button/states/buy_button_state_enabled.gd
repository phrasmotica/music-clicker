class_name BuyButtonStateEnabled
extends BuyButtonState

func _enter_tree() -> void:
	CustomLogger.debug("%s is now enabled" % _buy_button.name)
