class_name ProductMeterStateLocked
extends ProductMeterState

func _enter_tree() -> void:
	CustomLogger.debug("%s is now locked" % _product_meter.name)
