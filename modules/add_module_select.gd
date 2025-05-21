class_name AddModuleSelectDialog
extends Window


@onready var grid_container: GridContainer = $PanelContainer/Control/GridContainer


func _ready() -> void:
	for module: Dictionary in ModuleManager.available_modules:
		var new_button: Button = Button.new()
		new_button.text = module["title"]
		print(module["title"])
		
		new_button.pressed.connect(_on_module_button_pressed.bind(new_button))
		
		grid_container.add_child(new_button)


func _on_module_button_pressed(button_pressed: Button) -> void:
	# Get the path of the available module with the same title as the pressed button
	var module_path = ModuleManager.available_modules[ModuleManager.available_modules.find_custom(
		func(val: Dictionary):
			return true if val["title"] == button_pressed.text else false
	)]["path"]
	
	ModuleManager.load_module(module_path)
	
	visible = false
