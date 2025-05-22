class_name Menu
extends PanelContainer


var is_mouse_inside_top_bar := false
var is_following_mouse := false
var drag_offset: Vector2i

@onready var settings: Settings = $VSplitContainer/Settings
@onready var modules: HSplitContainer = $VSplitContainer/Modules


func _enter_tree() -> void:
	Nodes.menu = self


func _input(event: InputEvent) -> void:
	if is_mouse_inside_top_bar and event.is_action_pressed("click"):
		is_following_mouse = true
		drag_offset = -get_window().get_mouse_position()
	if event.is_action_released("click"):
		is_following_mouse = false


func _process(delta: float) -> void:
	if is_following_mouse:
		get_window().position = Vector2i(get_window().get_mouse_position()) + get_window().position + drag_offset
		return


func show_self() -> void:
	visible = true
	get_window().size = Vector2i(500, 400)


func _on_close_pressed():
	visible = false
	get_window().size = Vector2i.ZERO


func _on_settings_pressed() -> void:
	if settings.visible:
		settings.visible = false
		modules.visible = true
	else:
		settings.visible = true
		modules.visible = false


func _on_top_bar_mouse_entered() -> void:
	is_mouse_inside_top_bar = true


func _on_top_bar_mouse_exited() -> void:
	is_mouse_inside_top_bar = false
