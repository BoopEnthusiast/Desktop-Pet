class_name Main
extends Node2D


const FRAME_0000 = preload("res://Art/frame0000.png")

const SPEED = 400

var walks_around: bool = false

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var menu: Menu = $Menu
@onready var open_menu: Button = $OpenMenu


func _ready() -> void:
	get_window().size = sprite.scale * FRAME_0000.get_size()
	_load_settings.call_deferred()


func _load_settings() -> void:
	walks_around = Config.game_config_file.get_value("Gameplay", "walks_around", walks_around)


func _physics_process(delta: float) -> void:
	var window = get_window()
	var moving_in_rect: Rect2 = Rect2(window.position.x, window.position.y, window.size.x, window.size.y) # The rect of where the pet is moving to
	
	# Get the moving direction according to input
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down").normalized()
	moving_in_rect.position += direction * SPEED * delta
	
	# Get the middle of where is trying to be moved
	var moving_to_position: Vector2 = moving_in_rect.position + moving_in_rect.size / 2 
	
	# Make sure the window is inside the usable rect of the screen
	var outside_of_all_areas: bool = true
	for i in range(DisplayServer.get_screen_count()):
		var screen_usable_rect = DisplayServer.screen_get_usable_rect(i)
		if (
				moving_to_position.x < screen_usable_rect.end.x 
				and moving_to_position.x > screen_usable_rect.position.x 
				and moving_to_position.y < screen_usable_rect.end.y 
				and moving_to_position.y > screen_usable_rect.position.y
		):
			outside_of_all_areas = false
	
	# Move the pet if it's not moving outside of the screen
	if not outside_of_all_areas:
		window.position += Vector2i(direction * SPEED * delta)
	
	# Resize the window in case the scale has changed
	get_window().size = sprite.scale * FRAME_0000.get_size()


func _on_open_menu_pressed():
	menu.visible = not menu.visible
	open_menu.text = "^" if open_menu.text == "V" else "V"
