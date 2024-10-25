extends Node

@export
var product_meters: Array[ProductMeter]

func _on_score_manager_product_bought(product: Product) -> void:
	for pm in product_meters:
		if pm.product.id == product.id:
			pm.receive_product(1)
