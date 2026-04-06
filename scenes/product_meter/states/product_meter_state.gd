class_name ProductMeterState
extends Node

signal state_transition_requested(new_state: ProductMeter.State, state_data: ProductMeterStateData)

var _product_meter: ProductMeter = null
var _state_data: ProductMeterStateData = null
var _ui_updater: ProductMeterUIUpdater = null
var _interaction: ProductMeterInteraction = null
var _buyer: ProductBuyer = null
var _maker: ProductMaker = null

func setup(
	product_meter: ProductMeter,
	state_data: ProductMeterStateData,
	ui_updater: ProductMeterUIUpdater,
	interaction: ProductMeterInteraction,
	buyer: ProductBuyer,
	maker: ProductMaker,
) -> void:
	_product_meter = product_meter
	_state_data = state_data
	_ui_updater = ui_updater
	_interaction = interaction
	_buyer = buyer
	_maker = maker

func transition_state(
	new_state: ProductMeter.State,
	state_data := ProductMeterStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)

func lock() -> void:
	pass

func unlock() -> void:
	pass

func automate() -> void:
	pass

func is_locked() -> bool:
	return false

func is_automated() -> bool:
	return false

func can_unlock() -> bool:
	return false

func can_make() -> bool:
	return false

func can_buy() -> bool:
	return false

func can_automate() -> bool:
	return false
