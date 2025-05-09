class_name SettingsPanelVideo
extends SettingsPanel


@onready var msaa: OptionButton = $SettingsList/Setting/MSAA


func make_new_file_with_defaults() -> void:
	printerr("Make new file with defaults was called on Settings Panel instead of overwritten function")


func load_config() -> void:
	printerr("Load config was called on Settings Panel instead of overwritten function")


func set_global_config() -> void:
	Config.video_config_file = config_file
