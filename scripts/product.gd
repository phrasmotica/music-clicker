class_name Product extends Resource

@export
var id: int = 0

@export_placeholder("Name")
var product_name := ""

@export_range(1, 100)
var base_reward: int = 1

@export_range(1, 100)
var base_cost: int = 1
