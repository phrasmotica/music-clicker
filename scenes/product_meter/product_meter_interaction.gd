class_name ProductMeterInteraction
extends Node

@export
var make_button: Button

@export
var buy_button: BuyButton

@export
var automate_button: Button

@export
var unlock_button: Button

signal unlock_triggered
signal make_triggered
signal buy_triggered(amount: int)
signal automate_triggered

func _ready() -> void:
	if make_button:
		SignalHelper.chain(make_button.pressed, make_triggered)

	if buy_button:
		SignalHelper.chain(buy_button.buy_triggered, buy_triggered)

	if automate_button:
		SignalHelper.chain(automate_button.pressed, automate_triggered)

	if unlock_button:
		SignalHelper.chain(unlock_button.pressed, unlock_triggered)
