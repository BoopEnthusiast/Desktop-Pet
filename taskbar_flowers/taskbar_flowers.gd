class_name TaskbarFlowers
extends Module


const FLOWER = preload("res://taskbar_flowers/flower.tscn")

const VERTICAL_SIZE = 100

@onready var spawn_timer: Timer = $SpawnTimer


func _process(delta: float) -> void:
	var usable_rect: Rect2i = DisplayServer.screen_get_usable_rect(DisplayServer.get_primary_screen())
	size = Vector2i(usable_rect.size.x, VERTICAL_SIZE)
	position = Vector2i(usable_rect.position.x, usable_rect.end.y - size.y)


func _on_close_requested() -> void:
	visible = false


func _on_spawn_timer_timeout() -> void:
	var new_flower = FLOWER.instantiate()
	add_child(new_flower)
	var usable_rect: Rect2i = DisplayServer.screen_get_usable_rect(DisplayServer.get_primary_screen())
	new_flower.position.x = randf_range(0.0, usable_rect.size.x)
	spawn_timer.wait_time = randf_range(0.0, 10.0)
	spawn_timer.start()
