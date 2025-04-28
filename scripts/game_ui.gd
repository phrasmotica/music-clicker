@tool
class_name GameUI extends Node

@export_group("Dependencies")

@export
var score_manager: ScoreManager

@export
var product_router: ProductRouter

@onready
var product_meter_parent: Control = %ProductMeterParent

@onready
var score_label: Label = %ScoreLabel

var _product_meters: Array[ProductMeter] = []

signal buy_product(product: Product, cost: int)
signal made_product(reward: int)
signal automate_product(product: Product)

func _ready() -> void:
	if score_manager:
		score_manager.score_changed.connect(_handle_score_changed)
		score_manager.product_automated.connect(_handle_product_automated)

	if product_router:
		product_router.bought_product.connect(_handle_bought_product)

	for i in product_meter_parent.get_child_count():
		var meter: ProductMeter = product_meter_parent.get_child(i)
		_product_meters.append(meter)

	for pm in _product_meters:
		pm.buy_product.connect(buy_product.emit)
		pm.made_product.connect(made_product.emit)
		pm.automate_product.connect(automate_product.emit)

func _handle_bought_product(product: Product, amount: int) -> void:
	for pm in _product_meters:
		if pm.product == product:
			pm.set_amount(amount)

func _handle_score_changed(score: int) -> void:
	if score_label:
		score_label.text = "£" + str(score)

	for pm in _product_meters:
		pm.refresh_buttons(score)

func _handle_product_automated(product: Product) -> void:
	for pm in _product_meters:
		if pm.product == product:
			pm.set_automated()
