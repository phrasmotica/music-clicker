@tool
class_name BuyButtonAppearance
extends Node

@export
var buy_button: BuyButton

func refresh() -> void:
	if buy_button:
		buy_button.text = _get_button_text()

func _get_button_text() -> String:
	# TODO: inject the correct cost...
	var cost := 0
	return "Buy x%d £%d" % [buy_button.buy_amount, cost]
