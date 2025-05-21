class_name Menu
extends PanelContainer


@onready var settings: Settings = $VSplitContainer/Settings


func _enter_tree() -> void:
	Nodes.menu = self


func _on_close_pressed():
	visible = false


func _on_settings_pressed() -> void:
	settings.visible = not settings.visible
