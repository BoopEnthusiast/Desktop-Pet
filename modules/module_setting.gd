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
