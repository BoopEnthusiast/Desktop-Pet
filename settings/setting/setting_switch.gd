@tool
class_name SettingSwitch
extends Setting


signal switched(switched_on: bool)

@export var is_switched_on: bool:
	set(value):
		is_switched_on = value
		if is_instance_valid(_check_button):
			_check_button.button_pressed = value

@onready var _check_button: CheckButton = $CheckButton


func _ready() -> void:
	super()
	_check_button.button_pressed = is_switched_on


func _on_check_button_toggled(toggled_on: bool) -> void:
	switched.emit(toggled_on)
