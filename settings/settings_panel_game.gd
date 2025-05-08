class_name SettingsPanelGame
extends ScrollContainer


@export var config_file_name: String

@onready var walks_around = $SettingsList/Setting/WalksAround

var config_file: ConfigFile


func _ready():
	var err = config_file.load("user://%s" % config_file_name)
	
	# If it didn't load, go with the defaults
	if err != OK:
		return
