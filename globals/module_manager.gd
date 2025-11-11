extends Node


## Emitted after a module has loaded and been added as a child of this node.
signal loaded_module()
## Emitted after a module has been unloaded (hopefully, I'm not sure if queue_free will happen before or after call_deferred.)
signal unloaded_module()

## The list of available modules. Keys: "title", "path". The title is the title of the module, used for displaying the available modules when adding a new one.
var available_modules: Array[Dictionary] = [
	{
		"title": "Walking Pet",
		"path": "res://walking_pet/walking_pet.tscn",
	}, 
	{
		"title": "Taskbar Flowers",
		"path": "res://taskbar_flowers/taskbar_flowers.tscn",
	},
	{
		"title": "Blob",
		"path": "res://blob/blob.tscn"
	},
]
## The list of loaded in modules, these should all be children of this ModuleManager node.
var loaded_modules: Array[Module] = []


## Loads in a new module from the given path.
func load_module(path: String) -> void:
	var new_loaded_module: PackedScene = load(path)
	var new_module: Module = new_loaded_module.instantiate()
	loaded_modules.append(new_module)
	add_child(new_module)
	loaded_module.emit()


## Unloads the given module by freeing it.
func unload_module(module: Module) -> void:
	loaded_modules.remove_at(loaded_modules.find(module))
	module.queue_free()
	unloaded_module.emit.call_deferred()
