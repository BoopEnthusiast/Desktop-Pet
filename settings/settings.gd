class_name Settings
extends HSplitContainer


@onready var settings_panels = [$SettingsPanelGame]
@onready var settings_panel_game: SettingsPanelGame = $SettingsPanelGame


func hide_all_panels() -> void:
	for settings_panel in settings_panels:
		settings_panel.visible = false


func _on_game_pressed() -> void:
	hide_all_panels()
	settings_panel_game.visible = true
