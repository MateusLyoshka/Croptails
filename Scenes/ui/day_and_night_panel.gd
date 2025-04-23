extends Control

@onready var day_label: Label = $DayPanel/MarginContainer/DayLabel
@onready var time_label: Label = $TimePanel/MarginContainer/TimeLabel

@export var normal_speed: int = 5
@export var fast_speed: int = 100
@export var cheater_speed: int = 200

func _ready() -> void:
	DayAndNightManager.time_tick.connect(on_time_tick)
	
func on_time_tick(day: int, hour: int, minute: int) -> void:
	day_label.text = "Day " + str(day)
	time_label.text = "%02d:%02d" % [hour, minute]


func _on_normal_speed_pressed() -> void:
	DayAndNightManager.game_speed = normal_speed


func _on_fast_speed_pressed() -> void:
	DayAndNightManager.game_speed = fast_speed


func _on_cheater_speed_pressed() -> void:
	DayAndNightManager.game_speed = cheater_speed
