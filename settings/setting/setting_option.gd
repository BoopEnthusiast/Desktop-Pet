@tool
class_name SettingOption
extends Setting


signal item_selected(index: int)

@export var items: Array[String]:
	set(value):
		items = value
		if is_instance_valid(_option_button):
			_update_option_button_items()

@onready var _option_button: OptionButton = $OptionButton


func _ready() -> void:
	super()
	_update_option_button_items()


func _update_option_button_items() -> void:
	_option_button.clear()
	for item in items:
		_option_button.add_item(item)


func _on_option_button_item_selected(index: int) -> void:
	item_selected.emit(index)
