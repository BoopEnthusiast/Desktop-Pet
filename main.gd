extends Node2D


const SPEED = 400

var previous_monitor: int

@onready var icon: Sprite2D = $Icon
@onready var debug_window: Window = $Window


func _ready() -> void:
	get_window().size = icon.texture.get_size()



func _physics_process(delta: float) -> void:
	var window = get_window()
	var moving_in_rect: Rect2 = Rect2(window.position.x, window.position.y, window.size.x, window.size.y)
	
	# Get the moving direction according to input
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	moving_in_rect.position += direction * SPEED * delta
	
	debug_window.position = Vector2i(moving_in_rect.position + moving_in_rect.size / 2)
	
	# Make sure the window is inside the usable rect of the screen
	var moving_to_position: Vector2 = moving_in_rect.position + moving_in_rect.size / 2
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
			previous_monitor = i
	
	if not outside_of_all_areas:
		window.position += Vector2i(direction * SPEED * delta)
