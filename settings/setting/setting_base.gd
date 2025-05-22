@tool
class_name Setting
extends HBoxContainer


@export var setting_title: String:
	set(value):
		setting_title = value
		if is_instance_valid(_label):
			_label.text = value

@onready var _label = $Label


func _ready():
	_label.text = setting_title
