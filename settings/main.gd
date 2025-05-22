class_name Main
extends Node


@onready var menu: Menu = $Menu


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		menu.visible = true
		get_window().size = Vector2i(500, 400)
