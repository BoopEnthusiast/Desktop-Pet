class_name SettingsPanel
extends ScrollContainer


@export var config_file_name: String

var config_file: ConfigFile


func _ready() -> void:
	load_config()
	set_global_config()


func make_new_file_with_defaults() -> void:
	printerr("Make new file with defaults was called on Settings Panel instead of overwritten function")


func load_config() -> void:
	config_file = ConfigFile.new()
	var err = config_file.load("user://%s" % config_file_name)
	
	# If it fails to load, try making a new one
	if err != OK:
		make_new_file_with_defaults()
		return


func set_global_config() -> void:
	printerr("Set global config was called on Settings Panel instead of overwritten function")
