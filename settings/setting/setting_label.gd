@tool
class_name SettingLabel
extends Setting


@export var label_text: String:
	set(value):
		label_text = value
		if is_instance_valid(_label_2):
			_label_2.text = value

@onready var _label_2: Label = $Label2


func _ready() -> void:
	super()
	_label_2.text = label_text
