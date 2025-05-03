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
signal product_bought(product: Product)
signal product_automated(product: Product)

func _ready() -> void:
	if game_ui:
		game_ui.buy_product.connect(_handle_buy_product)
		game_ui.made_product.connect(_handle_made_product)
		game_ui.automate_product.connect(_handle_automate_product)

func _on_game_ready() -> void:
	_score = starting_score

	score_changed.emit(_score)

func _handle_buy_product(product: Product, cost: int) -> void:
	if _score < cost:
		return

	_score -= cost

	product_bought.emit(product)
	score_changed.emit(_score)

func _handle_made_product(reward:int) -> void:
	_score += reward
	score_changed.emit(_score)

func _handle_automate_product(product: Product) -> void:
	if not product or _score < product.automate_cost:
		return

	_score -= product.automate_cost

	score_changed.emit(_score)
	product_automated.emit(product)
