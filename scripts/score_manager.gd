@tool
class_name ScoreManager extends Node

@export
var starting_score: int = 0:
	set(value):
		starting_score = maxi(value, 0)

		if Engine.is_editor_hint():
			_score = starting_score

			score_changed.emit(_score)

var _score: int = 0

signal score_changed(score: int)

func _ready() -> void:
	if not Engine.is_editor_hint():
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

		SignalHelper.once_next_frame(_setup_score)

func _setup_score() -> void:
	_adjust_score(starting_score)

func _handle_unlock_product_requested(product: Product, cost: int) -> void:
	if _score < cost:
		return

	_adjust_score(_score - cost)

	GameEvents.emit_product_unlocked(product)

func _handle_buy_product_requested(product: Product, cost: int) -> void:
	if _score < cost:
		return

	_adjust_score(_score - cost)

	GameEvents.emit_product_bought(product)

func _handle_automate_product_requested(product: Product) -> void:
	if not product or _score < product.automate_cost:
		return

	_adjust_score(_score - product.automate_cost)

	GameEvents.emit_product_automated(product)

func _handle_product_made(reward: int) -> void:
	_adjust_score(_score + reward)

func _adjust_score(new_score: int) -> void:
	_score = new_score

	GameEvents.emit_score_changed(_score)
