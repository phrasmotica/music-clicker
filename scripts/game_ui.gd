@tool
class_name GameUI extends Node

@export
var starting_unlocked_products := 1:
	set(value):
		starting_unlocked_products = value

		_refresh()

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

signal unlock_product(product: Product, cost: int)
signal buy_product(product: Product, cost: int)
signal made_product(reward: int)
signal automate_product(product: Product)

func _ready() -> void:
	if score_manager:
		SignalHelper.persist(
			score_manager.score_changed,
			_handle_score_changed)

	if not Engine.is_editor_hint():
		SignalHelper.persist(
			GameEvents.score_changed,
			_handle_score_changed)

		SignalHelper.persist(
			GameEvents.product_automated,
			_handle_product_automated)

	for i in product_meter_parent.get_child_count():
		var meter: ProductMeter = product_meter_parent.get_child(i)
		_product_meters.append(meter)

	for pm in _product_meters:
		SignalHelper.chain(
			pm.unlock_product,
			unlock_product)

		SignalHelper.chain(
			pm.buy_product,
			buy_product)

		SignalHelper.chain(
			pm.made_product,
			made_product)

		SignalHelper.chain(
			pm.automate_product,
			automate_product)

	if product_router:
		SignalHelper.persist(
			product_router.products_changed,
			_inject_products)

		SignalHelper.persist(
			product_router.unlocked_product,
			_handle_unlocked_product)

		SignalHelper.persist(
			product_router.bought_product,
			_handle_bought_product)

		_inject_products(product_router.products)

	_refresh()

func _refresh() -> void:
	var meter_count := _product_meters.size()

	for i in meter_count:
		if i < starting_unlocked_products:
			_product_meters[i].to_unlocked()
		else:
			_product_meters[i].to_locked()

func _inject_products(products: Array[Product]) -> void:
	var product_count := products.size()
	var meter_count := _product_meters.size()

	for i in meter_count:
		var meter := _product_meters[i]

		if product_count > i:
			meter.product = products[i]
			meter.show()
		else:
			meter.product = null
			meter.hide()

func _handle_unlocked_product(product: Product, amount: int) -> void:
	for pm in _product_meters:
		if pm.product == product:
			print("%s unlocked" % product.product_name)

			pm.to_unlocked()
			pm.amount = amount

func _handle_bought_product(product: Product, amount: int, mult: float) -> void:
	for pm in _product_meters:
		if pm.product == product:
			print("%s amount=%d mult=%.1f" % [product.product_name, amount, mult])

			pm.amount = amount
			pm.mult = mult

func _handle_score_changed(score: int) -> void:
	if score_label:
		score_label.text = "£" + str(score)

	for pm in _product_meters:
		pm.update_score(score)

func _handle_product_automated(product: Product) -> void:
	for pm in _product_meters:
		if pm.product == product:
			pm.to_automated()
