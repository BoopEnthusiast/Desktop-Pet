class_name WalkingPet
extends Module


const FRAME_0000 = preload("res://art/frame0000.png")

const SPEED = 200
const BUFFER = 5

var inside_monitor: int = 0

var walks_around: bool = false
var walk_direction: Vector2

var is_mouse_inside: bool = false
var is_being_dragged: bool = false
var drag_offset: Vector2i = Vector2i.ZERO

@onready var sprite: WalkingPetSprite = $Sprite
@onready var walk_around_timer: Timer = $WalkAround


func _ready() -> void:
	super()
	get_window().size = sprite.scale * FRAME_0000.get_size()
	Config.updated_game_config.connect(_load_settings)


func _input(event: InputEvent) -> void:
	super(event)
	if event.is_action_pressed("click") and is_mouse_inside:
		is_being_dragged = true
		drag_offset = -get_mouse_position()
	elif event.is_action_released("click"):
		is_being_dragged = false


func _process(delta: float) -> void:
	if is_being_dragged:
		position = Vector2i(get_mouse_position()) + position + drag_offset
		return
	
	# Reset the position of the window if it's at (0, 0)
	if position == Vector2i.ZERO:
		_reset_position_to_center_of_primary_screen()
	
	# The rect of where the pet is moving to
	var moving_in_rect: Rect2 = Rect2(position.x, position.y, size.x, size.y) 
	
	# Get the moving direction according to input
	var direction: Vector2 = (Input.get_vector("left", "right", "up", "down") + walk_direction).normalized()
	moving_in_rect.position += direction * SPEED * delta
	
	# Get the monitor info of where moving to
	var inside_monitors: Array[int] = Utilities.monitors_rect_is_touching(moving_in_rect)
	var is_inside_single_monitor: bool = Utilities.is_inside_single_monitor(moving_in_rect)
	
	# Reset position if outside of all monitors
	if inside_monitors.size() == 0:
		_reset_position_to_center_of_primary_screen()
	
	# Set inside monitor for bouncing
	if is_inside_single_monitor:
		inside_monitor = inside_monitors[0]
	
	# Move the window if inside a single monitor or on the boundary between monitors
	if is_inside_single_monitor or inside_monitors.size() > 1:
		position += Vector2i(direction * SPEED * delta)
	# Otherwise, bounce off the edges of the monitor(s)
	else:
		var screen_usable_rect = DisplayServer.screen_get_usable_rect(inside_monitor)
		if moving_in_rect.end.x + BUFFER >= screen_usable_rect.end.x:
			walk_direction = walk_direction.bounce(Vector2.LEFT)
		elif moving_in_rect.position.x - BUFFER <= screen_usable_rect.position.x:
			walk_direction = walk_direction.bounce(Vector2.RIGHT)
		elif moving_in_rect.end.y + BUFFER >= screen_usable_rect.end.y:
			walk_direction = walk_direction.bounce(Vector2.UP)
		elif moving_in_rect.position.y - BUFFER <= screen_usable_rect.position.y:
			walk_direction = walk_direction.bounce(Vector2.DOWN)
	
	# Resize the window in case the scale has changed
	size = sprite.scale * FRAME_0000.get_size()


func _load_settings() -> void:
	walks_around = Config.game_config_file.get_value("Gameplay", "walks_around", walks_around)


func _reset_position_to_center_of_primary_screen() -> void:
	var primary_usable_rect = DisplayServer.screen_get_usable_rect(DisplayServer.SCREEN_PRIMARY)
	position = primary_usable_rect.end - primary_usable_rect.size / 2


func _on_walk_around_timeout() -> void:
	if walk_direction != Vector2.ZERO:
		walk_direction = Vector2.ZERO
		walk_around_timer.wait_time = randf_range(0.0, 60.0)
	else:
		walk_around_timer.wait_time = randf_range(1.0, 10.0)
		walk_direction = Vector2.from_angle(randf_range(0, TAU))
	walk_around_timer.start()


func _on_mouse_entered() -> void:
	is_mouse_inside = true


func _on_mouse_exited() -> void:
	is_mouse_inside = false
