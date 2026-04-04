extends Node

signal score_changed(score: int)

signal buy_product_requested(product: Product, cost: int)
signal unlock_product_requested(product: Product, cost: int)
signal automate_product_requested(product: Product)

signal product_made(reward: int)
signal product_bought(product: Product)
signal product_unlocked(product: Product)
signal product_automated(product: Product)

func emit_score_changed(score: int) -> void:
	score_changed.emit(score)

func emit_buy_product_requested(product: Product, cost: int) -> void:
	buy_product_requested.emit(product, cost)

func emit_unlock_product_requested(product: Product, cost: int) -> void:
	unlock_product_requested.emit(product, cost)

func emit_automate_product_requested(product: Product) -> void:
	automate_product_requested.emit(product)

func emit_product_made(reward: int) -> void:
	product_made.emit(reward)

func emit_product_bought(product: Product) -> void:
	product_bought.emit(product)

func emit_product_unlocked(product: Product) -> void:
	product_unlocked.emit(product)

func emit_product_automated(product: Product) -> void:
	product_automated.emit(product)
