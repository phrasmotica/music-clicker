extends Node

var _score: int = 0

signal score_changed(score: int)
signal product_bought(product: Product)

func _on_product_0_made_product(reward: int) -> void:
	_score += reward
	score_changed.emit(_score)

func _on_product_buy_product(product: Product, cost: int) -> void:
	if _score < cost:
		return

	_score -= cost

	score_changed.emit(_score)
	product_bought.emit(product)
