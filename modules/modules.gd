class_name Modules
extends HSplitContainer


@onready var add_module_select: AddModuleSelectDialog = $AddModuleSelect


func _on_add_module_pressed() -> void:
	add_module_select.visible = true
