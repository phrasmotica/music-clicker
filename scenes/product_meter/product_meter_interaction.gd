class_name ProductMeterInteraction
extends Node

@export
var make_button: Button

@export
var buy_button: Button

@export
var automate_button: Button

@export
var unlock_button: Button

signal unlock_triggered
signal make_triggered
signal buy_triggered
signal automate_triggered

func _ready() -> void:
	if make_button:
		SignalHelper.chain(make_button.pressed, make_triggered)

	if buy_button:
		SignalHelper.chain(buy_button.pressed, buy_triggered)

	if automate_button:
		SignalHelper.chain(automate_button.pressed, automate_triggered)

	if unlock_button:
		SignalHelper.chain(unlock_button.pressed, unlock_triggered)
