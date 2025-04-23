class_name GrowthCycleComponent
extends Node

@export var current_growth_state :DataTypes.GrowthStates = DataTypes.GrowthStates.Germination
@export_range(5, 365) var days_until_harvest: int = 5

signal crop_maturity
signal crop_harvesting

var is_watered: bool
var current_day: int
var starting_day: int

func _ready() -> void:
	DayAndNightManager.time_tick_day.connect(on_time_tick_day)

func on_time_tick_day(day: int) -> void:
	if is_watered:
		if starting_day == 0:
			starting_day = day
		growth_states(starting_day, day)
		harvest_state(starting_day, day)
		#is_watered = false  # Reseta o estado de rega

func growth_states(starting_day: int, current_day: int):
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		return

	var growth_days_passed = current_day - starting_day
	var max_state_index = DataTypes.GrowthStates.Maturity
	var state_index = clamp(growth_days_passed + 1, 0, max_state_index)

	var growth_keys = DataTypes.GrowthStates.keys()
	var state_name = growth_keys[state_index]
	current_growth_state = DataTypes.GrowthStates[state_name]

	print("current growth state: ", state_name, " (index: ", state_index, ")")

	if current_growth_state == DataTypes.GrowthStates.Maturity:
		crop_maturity.emit()

func harvest_state(starting_day: int, current_day: int) -> void:
	if current_growth_state == DataTypes.GrowthStates.Harvesting:
		return

	var days_passed = current_day - starting_day
	if days_passed >= days_until_harvest:
		current_growth_state = DataTypes.GrowthStates.Harvesting
		crop_harvesting.emit()

func get_current_growth_state() -> DataTypes.GrowthStates:
	return current_growth_state
