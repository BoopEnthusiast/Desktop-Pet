class_name Settings
extends HSplitContainer


@onready var settings_panels = [$SettingsPanelGame, $SettingsPanelVideo]
@onready var settings_panel_game: SettingsPanelGame = $SettingsPanelGame
@onready var settings_panel_video: SettingsPanelVideo = $SettingsPanelVideo


func _hide_all_panels() -> void:
	for settings_panel in settings_panels:
		settings_panel.visible = false


func _on_game_pressed() -> void:
	_hide_all_panels()
	settings_panel_game.visible = true


func _on_video_pressed() -> void:
	_hide_all_panels()
	settings_panel_video.visible = true
