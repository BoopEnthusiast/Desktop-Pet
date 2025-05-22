@tool
class_name SettingLine
extends Setting


signal text_submitted(new_text: String)

@export var default_text: String:
	set(value):
		default_text = value
		if is_instance_valid(_line_edit):
			_line_edit.text = value
@export var placeholder_text: String:
	set(value):
		placeholder_text = value
		if is_instance_valid(_line_edit):
			_line_edit.placeholder_text = value

@onready var _line_edit: LineEdit = $LineEdit


func _ready() -> void:
	super()
	_line_edit.text = default_text
	_line_edit.placeholder_text = placeholder_text


func _on_line_edit_text_submitted(new_text: String) -> void:
	text_submitted.emit(new_text)
