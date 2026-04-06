class_name ProductInfo

static func get_reward(product: Product, existing_amount: int, mult: float) -> int:
	if not product:
		return 0

	return int(mult * existing_amount * maxi(product.base_reward, 1))

static func get_cost(product: Product, existing_amount: int) -> int:
	if not product:
		return 0

	# https://www.desmos.com/calculator/w1vzpghz7i
	match product.cost_curve:
		Product.CurveType.LINEAR:
			return int(product.base_cost * existing_amount)

		Product.CurveType.LOGARITHMIC:
			return int(product.base_cost * pow(existing_amount, 0.7))

		Product.CurveType.EXPONENTIAL:
			return int(product.base_cost * pow(existing_amount, 1.2))

	return int(product.base_cost * existing_amount)

static func get_automate_cost(product: Product, ) -> int:
	return product.automate_cost if product else 0

static func get_unlock_cost(product: Product, ) -> int:
	return product.unlock_cost if product else 0
