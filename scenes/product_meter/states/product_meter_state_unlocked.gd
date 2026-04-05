class_name ProductMeterStateUnlocked
extends ProductMeterState

func _enter_tree() -> void:
	CustomLogger.debug("%s is now unlocked" % _product_meter.name)
