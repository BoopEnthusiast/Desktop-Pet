class_name SettingsPanelVideo
extends SettingsPanel


const SECTION_VIDEO = "Video"

@export_group("Defaults")
@export_range(0, 3) var msaa: int
@export var ssaa: bool

@onready var msaa_node: OptionButton = $SettingsList/Setting/MSAA
@onready var ssaa_node: CheckButton = $SettingsList/Setting2/SSAA


func make_new_file_with_defaults() -> void:
	config_file = ConfigFile.new()
	
	# MSAA
	config_file.set_value(SECTION_VIDEO, "msaa", msaa)
	msaa_node.selected = msaa
	# SSAA
	config_file.set_value(SECTION_VIDEO, "ssaa", ssaa)
	ssaa_node.button_pressed = ssaa
	
	var err = config_file.save("user://%s" % config_file_name)
	
	# Make sure it saved correctly
	assert(err == OK, "Failed to save video settings")


func load_config() -> void:
	super()
	
	msaa_node.selected = config_file.get_value(SECTION_VIDEO, "msaa", msaa)
	ssaa_node.button_pressed = config_file.get_value(SECTION_VIDEO, "ssaa", ssaa)
	
	Config.updated_video_config.emit()


func set_global_config() -> void:
	Config.video_config_file = config_file


func _on_msaa_item_selected(index: int) -> void:
	config_file.set_value(SECTION_VIDEO, "msaa", index)
	Config.updated_game_config.emit()


func _on_ssaa_toggled(toggled_on: bool) -> void:
	config_file.set_value(SECTION_VIDEO, "ssaa", toggled_on)
	Config.updated_game_config.emit()
