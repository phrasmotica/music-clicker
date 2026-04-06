@tool
class_name BuyButton
extends Button

enum State { DISABLED, ENABLED }

@export
var buy_amount := 1:
	set(value):
		buy_amount = maxi(value, 1)

		_refresh()

@onready
var appearance: BuyButtonAppearance = %Appearance

var _state_factory := BuyButtonStateFactory.new()
var _current_state: BuyButtonState = null

signal buy_triggered(amount: int)

func _ready() -> void:
	_refresh()

	if Engine.is_editor_hint():
		return

	switch_state(State.DISABLED)

func switch_state(state: State, state_data := BuyButtonStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "BuyButtonStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

func emit_buy_triggered() -> void:
	buy_triggered.emit(buy_amount)

func _refresh() -> void:
	if appearance:
		appearance.refresh()

func enable() -> void:
	if _current_state:
		_current_state.enable()

func disable() -> void:
	if _current_state:
		_current_state.disable()
