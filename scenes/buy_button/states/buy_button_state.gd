class_name BuyButtonState
extends Node

signal state_transition_requested(new_state: BuyButton.State, state_data: BuyButtonStateData)

var _buy_button: BuyButton = null
var _state_data: BuyButtonStateData = null

func setup(
	buy_button: BuyButton,
	state_data: BuyButtonStateData,
) -> void:
	_buy_button = buy_button
	_state_data = state_data

func transition_state(
	new_state: BuyButton.State,
	state_data := BuyButtonStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)
