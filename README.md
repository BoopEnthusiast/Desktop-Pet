# Desktop Pet

This repo is a collection of desktop interactibles, really, it's a framework which allows you to create desktop interactibles easily with a custom settings menu and all.

## Creating a new Module

1. Make a scene with the `Window` node as its root. 
2. Give it a script that extends `Module`.
3. Add it to `module_manager.gd`'s `available_modules` by creating a new dictionary with "title" and "path" set.

That's it! From there, it's just making a little Godot application in your scene.
