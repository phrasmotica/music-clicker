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

		# TODO: move this into one of the states?
		if maker and not Engine.is_editor_hint():
			maker.set_product(product)

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

@onready
var interaction: ProductMeterInteraction = %Interaction

@onready
var maker: ProductMaker = %Maker

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
		ui_updater,
		interaction,
		maker)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "ProductMeterStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

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

func is_making() -> bool:
	return _current_state and _current_state.is_making()

func is_locked() -> bool:
	return _current_state and _current_state.is_locked()

func is_unlocked() -> bool:
	return _current_state and _current_state.is_unlocked()

func is_automated() -> bool:
	return _current_state and _current_state.is_automated()

func can_make() -> bool:
	return _current_state and _current_state.can_make()

func can_buy() -> bool:
	return _current_state and _current_state.can_buy()

func can_automate() -> bool:
	return _current_state and _current_state.can_automate()

func can_unlock() -> bool:
	return _current_state and _current_state.can_unlock()

func get_amount() -> int:
	return amount if product else 0

func get_reward() -> int:
	return ProductInfo.get_reward(product, amount, mult)

func get_cost() -> int:
	return ProductInfo.get_cost(product, amount)

func get_automate_cost() -> int:
	return ProductInfo.get_automate_cost(product)

func get_unlock_cost() -> int:
	return ProductInfo.get_unlock_cost(product)

func update() -> void:
	_refresh()

func _refresh() -> void:
	if ui_updater:
		ui_updater.update_background()
		ui_updater.update_labels()
		ui_updater.update_buttons()
