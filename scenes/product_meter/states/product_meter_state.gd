class_name ProductMeterState
extends Node

signal state_transition_requested(new_state: ProductMeter.State, state_data: ProductMeterStateData)

var _product_meter: ProductMeter = null
var _state_data: ProductMeterStateData = null

func setup(
	product_meter: ProductMeter,
	state_data: ProductMeterStateData,
) -> void:
	_product_meter = product_meter
	_state_data = state_data

func transition_state(
	new_state: ProductMeter.State,
	state_data := ProductMeterStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)
