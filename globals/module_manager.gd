extends Node


signal loaded_module()
signal unloaded_module()

var available_modules: Array[Dictionary] = [
	{
		"title": "Walking Pet",
		"path": "res://walking_pet/walking_pet.tscn",
	}, 
	{
		"title": "Taskbar Flowers",
		"path": "res://taskbar_flowers/taskbar_flowers.tscn",
	},
]
var loaded_modules: Array[Module] = []


## Loads in a new module from the given path
func load_module(path: String) -> void:
	var new_module = load(path)
	# TODO: Load in the module and do stuff properly
	loaded_module.emit()


## Unloads the given module by freeing it
func unload_module(module: Module) -> void:
	loaded_modules[loaded_modules.find(module)].queue_free()
	unloaded_module.emit()
