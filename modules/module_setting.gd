class_name ModuleSetting
extends Resource


enum SettingType {
	LABEL,
	SWITCH,
	OPTION,
	LINE,
}

@export var setting_name: String
@export var setting_type: SettingType

@export_category("Setting defaults")
@export var label_text: String
@export var switch_value: bool
@export var option_items: Array[String]
@export var line_text: String
@export var line_placeholder_text: String
