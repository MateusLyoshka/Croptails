extends Node

var tool_selected: DataTypes.Tools = DataTypes.Tools.None

signal select_tool(tool: DataTypes.Tools)

func tool_select(tool: DataTypes.Tools) -> void:
	select_tool.emit(tool)
	tool_selected = tool
