class_name SettingsPanel
extends ScrollContainer


@export var config_file_name: String

var config_file: ConfigFile


func _ready() -> void:
	# Make sure the config file exists
	if not is_instance_valid(config_file):
		# If it hasn't, try loading config
		load_config()
	else:
		var err = config_file.load("user://%s" % config_file_name)
	
		# If it didn't load, go with the defaults
		if err != OK:
			make_new_file_with_defaults()
	
	set_global_config()


func make_new_file_with_defaults() -> void:
	printerr("ERROR: Make new file with defaults was called on Settings Panel instead of overwritten function")


func load_config() -> void:
	printerr("ERROR: Load config was called on Settings Panel instead of overwritten function")


func set_global_config() -> void:
	printerr("ERROR: Set global config was called on Settings Panel instead of overwritten function")
