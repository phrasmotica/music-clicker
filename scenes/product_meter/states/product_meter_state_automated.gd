class_name ProductMeterStateAutomated
extends ProductMeterState

func _enter_tree() -> void:
	CustomLogger.debug("%s is now automated" % _product_meter.name)
