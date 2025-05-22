class_name ModuleSettingsList
extends ScrollContainer


signal setting_switch_switched(switched_on: bool, setting_switch: SettingSwitch)
signal setting_option_selected(index: int, setting_option: SettingOption)
signal setting_line_submitted(text: String, setting_line: SettingLine)

const SETTING_LABEL = preload("res://settings/setting/setting_label.tscn")
const SETTING_SWITCH = preload("res://settings/setting/setting_switch.tscn")
const SETTING_OPTION = preload("res://settings/setting/setting_option.tscn")
const SETTING_LINE = preload("res://settings/setting/setting_line.tscn")

var settings: Array[Setting] = []

@onready var settings_list: VBoxContainer = $SettingsList


## Adds a new Setting to to settings and as a child of settings_list, and returns that setting
func add_setting(module_setting: ModuleSetting) -> void:
	var new_setting_scene: Setting
	match module_setting.setting_type:
		ModuleSetting.SettingType.LABEL:
			new_setting_scene = SETTING_LABEL.instantiate() as SettingLabel
			new_setting_scene.label_text = module_setting.label_text
		ModuleSetting.SettingType.SWITCH:
			new_setting_scene = SETTING_SWITCH.instantiate() as SettingSwitch
			new_setting_scene.is_switched_on = module_setting.switch_value
			new_setting_scene.switched.connect(_setting_switch_switched.bind(new_setting_scene))
		ModuleSetting.SettingType.OPTION:
			new_setting_scene = SETTING_OPTION.instantiate() as SettingOption
			new_setting_scene.items = module_setting.option_items
			new_setting_scene.item_selected.connect(_setting_option_selected.bind(new_setting_scene))
		ModuleSetting.SettingType.LINE:
			new_setting_scene = SETTING_LINE.instantiate() as SettingLine
			new_setting_scene.default_text = module_setting.line_text
			new_setting_scene.placeholder_text = module_setting.line_placeholder_text
			new_setting_scene.text_submitted.connect(_setting_line_submitted.bind(new_setting_scene))
	
	new_setting_scene.setting_title = module_setting.setting_name
	
	settings_list.add_child(new_setting_scene)
	settings.append(new_setting_scene)


func _setting_switch_switched(switched_on: bool, setting_switch: SettingSwitch) -> void:
	setting_switch_switched.emit(switched_on, setting_switch)


func _setting_option_selected(index: int, setting_option: SettingOption) -> void:
	setting_option_selected.emit(index, setting_option)


func _setting_line_submitted(text: String, setting_line: SettingLine) -> void:
	setting_line_submitted.emit(text, setting_line)
