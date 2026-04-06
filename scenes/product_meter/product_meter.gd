@tool
class_name ProductMeter
extends PanelContainer

enum State { LOCKED, UNLOCKED, AUTOMATED }

@export
var product: Product:
	set(value):
		product = value

		if product:
			SignalHelper.persist(product.changed, _refresh)

		_refresh()

@export
var amount: int = 1:
	set(value):
		amount = maxi(value, 0)

		_refresh()

@export
var mult: float = 1.0:
	set(value):
		var old := mult
		var new := maxf(value, 0.0)

		mult = new

		_refresh()

		if not Engine.is_editor_hint() and old != new and ui_updater:
			ui_updater.highlight_reward()

@export
var locked_colour: Color:
	set(value):
		locked_colour = value

		_refresh()

@onready
var ui_updater: ProductMeterUIUpdater = %UIUpdater

var _state_factory := ProductMeterStateFactory.new()
var _current_state: ProductMeterState = null

func _ready() -> void:
	_refresh()

	if Engine.is_editor_hint():
		return

	switch_state(State.LOCKED)

func switch_state(state: State, state_data := ProductMeterStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data,
		ui_updater)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "ProductMeterStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

func get_amount() -> int:
	return amount if product else 0

func get_reward() -> int:
	if not product:
		return 0

	return int(mult * amount * maxi(product.base_reward, 1))

func get_cost() -> int:
	if not product:
		return 0

	# https://www.desmos.com/calculator/w1vzpghz7i
	match product.cost_curve:
		Product.CurveType.LINEAR:
			return int(product.base_cost * amount)

		Product.CurveType.LOGARITHMIC:
			return int(product.base_cost * pow(amount, 0.7))

		Product.CurveType.EXPONENTIAL:
			return int(product.base_cost * pow(amount, 1.2))

	return int(product.base_cost * amount)

func get_automate_cost() -> int:
	return product.automate_cost if product else 0

func get_unlock_cost() -> int:
	return product.unlock_cost if product else 0

func lock() -> void:
	if Engine.is_editor_hint():
		ui_updater.lock()
	elif _current_state:
		_current_state.lock()

func unlock() -> void:
	if Engine.is_editor_hint():
		ui_updater.unlock()
	elif _current_state:
		_current_state.unlock()

func automate() -> void:
	if Engine.is_editor_hint():
		ui_updater.automate()
	elif _current_state:
		_current_state.automate()

func is_locked() -> bool:
	return _current_state and _current_state.is_locked()

func is_unlocked() -> bool:
	return _current_state and _current_state.is_unlocked()

func is_automated() -> bool:
	return _current_state and _current_state.is_automated()

func _refresh() -> void:
	if ui_updater:
		ui_updater.update_labels()
		ui_updater.update_buttons()

func update() -> void:
	_refresh()
