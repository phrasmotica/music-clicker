class_name BuyButtonStateFactory

var states: Dictionary

func _init() -> void:
	states = {
		BuyButton.State.DISABLED: BuyButtonStateDisabled,
		BuyButton.State.ENABLED: BuyButtonStateEnabled,
	}

func get_fresh_state(state: BuyButton.State) -> BuyButtonState:
	assert(states.has(state), "State is missing!")
	return states.get(state).new()
