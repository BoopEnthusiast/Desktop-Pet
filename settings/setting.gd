@tool
class_name Setting
extends HBoxContainer


@export var setting_title: String

@onready var _label = $Label


func _ready():
	_label.text = setting_title
