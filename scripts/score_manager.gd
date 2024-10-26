@tool
extends Node

@export
var starting_score: int = 0

var _score: int = 0

signal score_changed(score: int)
signal product_bought(product: Product)

func _on_ui_manager_ui_ready() -> void:
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
