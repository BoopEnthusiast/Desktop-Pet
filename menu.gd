class_name Menu
extends Window


func _ready() -> void:
	pass#if OS.get_name() == "Linux":
		#borderless = false


func _on_close_pressed():
	visible = false
