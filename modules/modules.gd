class_name Modules
extends HSplitContainer


const MODULE_SETTINGS = preload("res://modules/module_settings.tscn")

@onready var add_module_select: AddModuleSelectDialog = $AddModuleSelect

@onready var module_list_scroll_box: ScrollContainer = $ModuleListScrollBox
@onready var modules_list: VBoxContainer = $ModuleListScrollBox/ModulesList
@onready var add_module: Button = $ModuleListScrollBox/ModulesList/AddModule


var modules: Array[Dictionary] = [
	{ # Example, will be cleared when _reset_modules is inexorably called
		"button": Button.new(),
		"settings": ModuleSettings.new(),
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
		i += 1


## Creates a new ModuleSettings for each module in ModuleManager.loaded_modules, and sets up their settings
func _setup_module_settings_list() -> void:
	var i = 0
	for module: Module in ModuleManager.loaded_modules:
		var new_module_settings: ModuleSettings = MODULE_SETTINGS.instantiate()
		
		
		print("Created new module")
		i += 1


func _add_to_modules(index, button = null, settings = null) -> void:
	#if modules.size() < index: # TODO: Test if this is needed
		#modules.append({})
	modules[index]["button"] = button
	modules[index]["settings"] = settings


func _on_add_module_pressed() -> void:
	add_module_select.visible = true


func _on_module_setting_pressed(button_pressed: Button) -> void:
	pass
