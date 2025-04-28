@tool
extends Node

@onready
var product_meter_parent: Control = %ProductMeterParent

@onready
var score_label: Label = %ScoreLabel

var _product_meters: Array[ProductMeter] = []

signal buy_product(product: Product, cost: int)
signal made_product(reward: int)
signal automate_product(product: Product)

func _ready() -> void:
	for i in product_meter_parent.get_child_count():
		var meter: ProductMeter = product_meter_parent.get_child(i)
		_product_meters.append(meter)

	for pm in _product_meters:
		pm.buy_product.connect(buy_product.emit)
		pm.made_product.connect(made_product.emit)
		pm.automate_product.connect(automate_product.emit)

func _on_product_router_bought_product(product: Product, amount: int) -> void:
	for pm in _product_meters:
		if pm.product == product:
			pm.set_amount(amount)

func _on_score_manager_score_changed(score: int) -> void:
	if score_label:
		score_label.text = "£" + str(score)

	for pm in _product_meters:
		pm.refresh_buttons(score)

func _on_score_manager_product_automated(product: Product) -> void:
	for pm in _product_meters:
		if pm.product == product:
			pm.set_automated()
