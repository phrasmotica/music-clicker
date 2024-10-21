class_name Product extends Resource

@export_placeholder("Name")
var product_name := ""

@export_range(1.0, 10.0)
var base_time_seconds: float = 3.0

@export_range(1, 100)
var base_reward: int = 1

@export_range(1, 100)
var base_cost: int = 1
