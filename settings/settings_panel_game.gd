class_name SettingsPanelGame
extends SettingsPanel


@export_group("Defaults")
@export var walks_around: bool

@onready var walks_around_node = $SettingsList/Setting/WalksAround



func make_new_file_with_defaults() -> void:
	config_file = ConfigFile.new()
	
	# Walks around
	config_file.set_value("Gameplay", "walks_around", walks_around)
	walks_around_node.button_pressed = walks_around
	
	config_file.save("user://%s" % config_file_name)


func load_config() -> void:
	config_file = ConfigFile.new()
	config_file.load("user://%s" % config_file_name)
	
	walks_around_node.button_pressed = config_file.get_value("Gameplay", "walks_around", walks_around)


func set_global_config() -> void:
	Config.game_config_file = config_file
