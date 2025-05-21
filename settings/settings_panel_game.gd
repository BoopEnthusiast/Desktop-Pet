class_name SettingsPanelGame
extends SettingsPanel


const SECTION_GAMEPLAY = "Gameplay"

@export_group("Defaults")



func make_new_file_with_defaults() -> void:
	config_file = ConfigFile.new()
	
	var err = config_file.save("user://%s" % config_file_name)
	
	# Make sure it saved correctly
	if err != OK:
		print("Failed to save video settings")
		print(error_string(err))


func load_config() -> void:
	super()
	
	Config.updated_game_config.emit()


func set_global_config() -> void:
	Config.game_config_file = config_file
