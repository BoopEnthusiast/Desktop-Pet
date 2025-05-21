class_name Menu
extends PanelContainer


@onready var settings: Settings = $VSplitContainer/Settings
@onready var modules: HSplitContainer = $VSplitContainer/Modules


func _enter_tree() -> void:
	Nodes.menu = self


func _on_close_pressed():
	visible = false
	get_window().size = Vector2i.ZERO


func _on_settings_pressed() -> void:
	if settings.visible:
		settings.visible = false
		modules.visible = true
	else:
		settings.visible = true
		modules.visible = false
