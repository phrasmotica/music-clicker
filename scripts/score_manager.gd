@tool
extends Node

@export
var starting_score: int = 0:
	set(value):
		starting_score = value

		if Engine.is_editor_hint():
			_score = starting_score

			score_changed.emit(_score)

var _score: int = 0

signal score_changed(score: int)
signal product_bought(product: Product)
signal product_automated(product: Product)

func _on_ui_manager_ready() -> void:
	_score = starting_score

	score_changed.emit(_score)

func _on_product_router_buy_product(product:Product, cost:int) -> void:
	if _score < cost:
		return

	_score -= cost

	score_changed.emit(_score)
	product_bought.emit(product)

func _on_product_router_made_product(reward:int) -> void:
	_score += reward
	score_changed.emit(_score)

func _on_product_router_automate_product(product:Product, automate_cost:int) -> void:
	if _score < automate_cost:
		return

	_score -= automate_cost

	score_changed.emit(_score)
	product_automated.emit(product)
