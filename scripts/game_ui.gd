@tool
extends Node

@export
var product_meters: Array[ProductMeter] = []

@onready
var score_label: Label = %ScoreLabel

signal buy_product(product: Product, cost: int)
signal made_product(reward: int)
signal automate_product(product: Product)

func _ready() -> void:
	for pm in product_meters:
		pm.buy_product.connect(buy_product.emit)
		pm.made_product.connect(made_product.emit)
		pm.automate_product.connect(automate_product.emit)

func _on_product_router_bought_product(product: Product, amount: int) -> void:
	for pm in product_meters:
		if pm.product == product:
			pm.set_amount(amount)

func _on_score_manager_score_changed(score: int) -> void:
	if score_label:
		score_label.text = "£" + str(score)

	for pm in product_meters:
		pm.refresh_buttons(score)

func _on_score_manager_product_automated(product: Product) -> void:
	for pm in product_meters:
		if pm.product == product:
			pm.set_automated()
