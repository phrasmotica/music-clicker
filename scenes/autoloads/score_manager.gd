extends Node

var _score: int = 0

func _ready() -> void:
	SignalHelper.persist(
		GameEvents.unlock_product_requested,
		_handle_unlock_product_requested)

	SignalHelper.persist(
		GameEvents.buy_product_requested,
		_handle_buy_product_requested)

	SignalHelper.persist(
		GameEvents.automate_product_requested,
		_handle_automate_product_requested)

	SignalHelper.persist(
		GameEvents.product_made,
		_handle_product_made)

func set_starting_score(starting_score: int) -> void:
	_adjust_score(starting_score)

func _handle_unlock_product_requested(product: Product, cost: int) -> void:
	if can_afford(cost):
		_adjust_score(_score - cost)

		GameEvents.emit_product_unlocked(product)

func _handle_buy_product_requested(product: Product, cost: int) -> void:
	if can_afford(cost):
		_adjust_score(_score - cost)

		GameEvents.emit_product_bought(product)

func _handle_automate_product_requested(product: Product) -> void:
	if not product:
		return

	if can_afford(product.automate_cost):
		_adjust_score(_score - product.automate_cost)

		GameEvents.emit_product_automated(product)

func _handle_product_made(reward: int) -> void:
	_adjust_score(_score + reward)

func _adjust_score(new_score: int) -> void:
	_score = new_score

	GameEvents.emit_score_changed(_score)

func can_afford(cost: int) -> bool:
	return _score >= cost
