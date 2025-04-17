extends PanelContainer

@onready var tool_axe: Button = $MarginContainer/HBoxContainer/ToolAxe
@onready var tool_tiling: Button = $MarginContainer/HBoxContainer/ToolTiling
@onready var tool_watering_can: Button = $MarginContainer/HBoxContainer/ToolWateringCan
@onready var tool_corn: Button = $MarginContainer/HBoxContainer/ToolCorn
@onready var tool_tomato: Button = $MarginContainer/HBoxContainer/ToolTomato

func _on_tool_axe_pressed() -> void:
	ToolManager.tool_select(DataTypes.Tools.AxeWood)

func _on_tool_tiling_pressed() -> void:
	ToolManager.tool_select(DataTypes.Tools.TillGround)

func _on_tool_watering_can_pressed() -> void:
	ToolManager.tool_select(DataTypes.Tools.WaterCrops)

func _on_tool_corn_pressed() -> void:
	ToolManager.tool_select(DataTypes.Tools.PlantCorn)

func _on_tool_tomato_pressed() -> void:
	ToolManager.tool_select(DataTypes.Tools.PlantTomato)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("release_tool"):
		ToolManager.tool_select(DataTypes.Tools.None)
		tool_axe.release_focus()
		tool_corn.release_focus()
		tool_tiling.release_focus()
		tool_tomato.release_focus()
		tool_watering_can.release_focus()
