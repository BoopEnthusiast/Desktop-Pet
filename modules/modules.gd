class_name Modules
extends HSplitContainer


const MODULE_SETTINGS_LIST = preload("res://modules/module_settings_list.tscn")

@onready var add_module_select: AddModuleSelectDialog = $AddModuleSelect

@onready var module_list_scroll_box: ScrollContainer = $ModuleListScrollBox
@onready var modules_list: VBoxContainer = $ModuleListScrollBox/ModulesList
@onready var add_module: Button = $ModuleListScrollBox/ModulesList/AddModule


var modules: Array[Dictionary] = [
	{ # Example, will be cleared when _reset_modules is inexorably called
		"button": Button.new(),
		"settings": ModuleSettingsList.new(),
	}
]


func _ready() -> void:
	ModuleManager.loaded_module.connect(_reset_modules)
	ModuleManager.unloaded_module.connect(_reset_modules)


func _reset_modules() -> void:
	# Remove the current modules
	modules.clear()
	_remove_modules_from_module_list()
	_remove_module_settings()
	# Add the new modules
	_setup_module_list()
	_setup_module_settings_list()


## Removes the module buttons from modules_list
func _remove_modules_from_module_list() -> void:
	for child: Button in modules_list.get_children():
		if not child == add_module:
			modules_list.remove_child(child)


## Removes the module settings from this node
func _remove_module_settings() -> void:
	for child: Node in get_children():
		# Must be a ScrollContainer and not module_list_scroll_box
		if child is ScrollContainer and not child == module_list_scroll_box:
			remove_child(child)


## Creates a new button under modules_list for each module in ModuleManager.loaded_modules
func _setup_module_list() -> void:
	var i = 0
	for module: Module in ModuleManager.loaded_modules:
		var new_module_select_button: Button = Button.new()
		new_module_select_button.pressed.connect(_on_module_setting_pressed.bind(new_module_select_button))
		_add_to_modules(i, new_module_select_button)
		modules_list.add_child(new_module_select_button)
		modules_list.move_child(new_module_select_button, 0) # Move it to the top of the list
		i += 1


## Creates a new ModuleSettings for each module in ModuleManager.loaded_modules, and sets up their settings
func _setup_module_settings_list() -> void:
	var i = 0
	for module: Module in ModuleManager.loaded_modules:
		var new_module_settings: ModuleSettingsList = MODULE_SETTINGS_LIST.instantiate()
		
		i += 1


func _add_to_modules(index, button = null, settings = null) -> void:
	if modules.size() <= index:
		modules.append({})
	if button != null:
		modules[index]["button"] = button
	if settings != null:
		modules[index]["settings"] = settings


func _on_add_module_pressed() -> void:
	add_module_select.visible = true


func _on_module_setting_pressed(button_pressed: Button) -> void:
	pass
