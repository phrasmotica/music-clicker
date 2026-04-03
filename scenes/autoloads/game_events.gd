extends Node

signal product_bought(product: Product)
signal product_unlocked(product: Product)
signal product_automated(product: Product)

func emit_product_bought(product: Product) -> void:
	product_bought.emit(product)

func emit_product_unlocked(product: Product) -> void:
	product_unlocked.emit(product)

func emit_product_automated(product: Product) -> void:
	product_automated.emit(product)
