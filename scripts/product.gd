@tool
class_name Product extends Resource

enum CurveType { LINEAR, LOGARITHMIC, EXPONENTIAL }

@export
var id: int = 0

@export_placeholder("Name")
var product_name := ""

@export_range(1, 100)
var base_reward: int = 1

@export_range(1, 100)
var base_cost: int = 1

@export
var multipliers: Dictionary[int, float] = {}

@export_range(1.0, 30.0)
var base_time_seconds: float = 3.0

@export
var cost_curve: CurveType

@export_range(1000, 100_000)
var unlock_cost: int = 1000:
    set(value):
        unlock_cost = value

        emit_changed()

@export_range(100, 5000)
var automate_cost: int = 100:
    set(value):
        automate_cost = value

        emit_changed()

@export
var colour: Color:
    set(value):
        colour = value

        emit_changed()
