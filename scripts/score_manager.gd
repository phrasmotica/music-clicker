@tool
class_name ScoreManager extends Node

@export
var starting_score: int = 0:
	set(value):
		starting_score = maxi(value, 0)

		if Engine.is_editor_hint():
			_score = starting_score

			score_changed.emit(_score)

@export_group("Dependencies")

@export
var game_ui: GameUI

var _score: int = 0

signal score_changed(score: int)

func _ready() -> void:
	if game_ui:
		SignalHelper.persist(
			game_ui.unlock_product,
			_handle_unlock_product)

		SignalHelper.persist(
			game_ui.buy_product,
			_handle_buy_product)

		SignalHelper.persist(
			game_ui.made_product,
			_handle_made_product)

		SignalHelper.persist(
			game_ui.automate_product,
			_handle_automate_product)

	if not Engine.is_editor_hint():
		SignalHelper.once_next_frame(_setup_score)

func _setup_score() -> void:
	_adjust_score(starting_score)

func _handle_unlock_product(product: Product, cost: int) -> void:
	if _score < cost:
		return

	_adjust_score(_score - cost)

	GameEvents.emit_product_unlocked(product)

func _handle_buy_product(product: Product, cost: int) -> void:
	if _score < cost:
		return

	_adjust_score(_score - cost)

	GameEvents.emit_product_bought(product)

func _handle_made_product(reward: int) -> void:
	_adjust_score(_score + reward)

func _handle_automate_product(product: Product) -> void:
	if not product or _score < product.automate_cost:
		return

	_adjust_score(_score - product.automate_cost)

	GameEvents.emit_product_automated(product)

func _adjust_score(new_score: int) -> void:
	_score = new_score

	GameEvents.emit_score_changed(_score)
