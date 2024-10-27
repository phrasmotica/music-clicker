@tool
extends Node

@export
var product_meters: Array[ProductMeter] = []

@export
var amounts: Dictionary = {}

signal buy_product(product: Product, cost: int)
signal made_product(reward: int)
signal automate_product(product: Product)

func _ready():
	for pm in product_meters:
		pm.buy_product.connect(handle_product_meter_buy_product)
		pm.made_product.connect(handle_product_meter_made_product)
		pm.automate_product.connect(handle_product_meter_automate_product)

func add_product(id: int, amount: int) -> void:
	if amounts.has(id):
		amounts[id] += amount
	else:
		amounts[id] = amount

func get_amount(id: int) -> int:
	return amounts.get(id, 0)

func handle_product_meter_buy_product(product: Product, cost: int) -> void:
	buy_product.emit(product, cost)

func handle_product_meter_made_product(reward: int) -> void:
	made_product.emit(reward)

func handle_product_meter_automate_product(product: Product, automate_cost: int) -> void:
	automate_product.emit(product, automate_cost)

func _on_score_manager_product_bought(product: Product) -> void:
	add_product(product.id, 1)

	for pm in product_meters:
		var amount := get_amount(pm.product.id)
		pm.set_amount(amount)

func _on_score_manager_score_changed(score: int) -> void:
	for pm in product_meters:
		pm.refresh_buttons(score)

func _on_score_manager_product_automated(product: Product) -> void:
	for pm in product_meters:
		if pm.product == product:
			pm.set_automated()
