class_name ProductMeterStateFactory

var states: Dictionary

func _init() -> void:
	states = {
		ProductMeter.State.LOCKED: ProductMeterStateLocked,
		ProductMeter.State.UNLOCKED: ProductMeterStateUnlocked,
		ProductMeter.State.AUTOMATED: ProductMeterStateAutomated,
	}

func get_fresh_state(state: ProductMeter.State) -> ProductMeterState:
	assert(states.has(state), "State is missing!")
	return states.get(state).new()
