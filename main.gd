class_name Main
extends Node2D


const FRAME_0000 = preload("res://art/frame0000.png")

const SPEED = 200

var inside_monitor: int = 0

var walks_around: bool = false
var walk_direction: Vector2

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var menu: Menu = $Menu
@onready var open_menu: Button = $OpenMenu
@onready var walk_around_timer: Timer = $WalkAround


func _ready() -> void:
	get_window().size = sprite.scale * FRAME_0000.get_size()
	load_settings.call_deferred()


func load_settings() -> void:
	walks_around = Config.game_config_file.get_value("Gameplay", "walks_around", walks_around)


func _physics_process(delta: float) -> void:
	var window = get_window()
	var moving_in_rect: Rect2 = Rect2(window.position.x, window.position.y, window.size.x, window.size.y) # The rect of where the pet is moving to
	
	# Get the moving direction according to input
	var direction: Vector2 = (Input.get_vector("left", "right", "up", "down") + walk_direction).normalized()
	moving_in_rect.position += direction * SPEED * delta
	
	# Make sure the window is inside the usable rect of the screen
	var outside_of_all_areas: bool = true
	for i in range(DisplayServer.get_screen_count()):
		var screen_usable_rect = DisplayServer.screen_get_usable_rect(i)
		if (
				moving_in_rect.end.x < screen_usable_rect.end.x 
				and moving_in_rect.position.x > screen_usable_rect.position.x 
				and moving_in_rect.end.y < screen_usable_rect.end.y 
				and moving_in_rect.position.y > screen_usable_rect.position.y
		):
			outside_of_all_areas = false
			inside_monitor = i
	
	# Move the pet if it's not moving outside of the screen
	if not outside_of_all_areas:
		window.position += Vector2i(direction * SPEED * delta)
	# Bounce off the edges of the screen
	else:
		var screen_usable_rect = DisplayServer.screen_get_usable_rect(inside_monitor)
		if moving_in_rect.end.x >= screen_usable_rect.end.x:
			walk_direction = walk_direction.bounce(Vector2.LEFT)
		elif moving_in_rect.position.x <= screen_usable_rect.position.x:
			walk_direction = walk_direction.bounce(Vector2.RIGHT)
		elif moving_in_rect.end.y >= screen_usable_rect.end.y:
			walk_direction = walk_direction.bounce(Vector2.UP)
		elif moving_in_rect.position.y <= screen_usable_rect.position.y:
			walk_direction = walk_direction.bounce(Vector2.DOWN)
	
	# Resize the window in case the scale has changed
	window.size = sprite.scale * FRAME_0000.get_size()


func _on_open_menu_pressed():
	menu.visible = not menu.visible
	open_menu.text = "^" if open_menu.text == "V" else "V"


func _on_walk_around_timeout() -> void:
	if walk_direction != Vector2.ZERO:
		walk_direction = Vector2.ZERO
		walk_around_timer.wait_time = randf_range(0.0, 60.0)
	else:
		walk_around_timer.wait_time = randf_range(3.0, 10.0)
		walk_direction = Vector2.from_angle(randf_range(0, TAU))
		var usable_rect = DisplayServer.screen_get_usable_rect(inside_monitor)
		walk_direction += Vector2(get_window().position).direction_to(Vector2(usable_rect.end - usable_rect.size / 2)) / 2
	walk_around_timer.start()
