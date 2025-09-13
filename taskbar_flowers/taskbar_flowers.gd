class_name TaskbarFlowers
extends Module


const FLOWER = preload("res://taskbar_flowers/flower.tscn")
const VERTICAL_SIZE = 100

var flowers: Array[Flower]

@onready var spawn_timer: Timer = $SpawnTimer
@onready var merge_polygon: Polygon2D = $MergePolygon
@onready var debug: Polygon2D = $Debug


func _ready() -> void:
	size_changed.connect(_update_screen)
	focus_entered.connect(_update_screen)
	focus_exited.connect(_update_screen)
	mouse_entered.connect(_update_screen)
	mouse_exited.connect(_update_screen)


func _on_close_requested() -> void:
	visible = false


func _on_spawn_timer_timeout() -> void:
	var new_flower = FLOWER.instantiate()
	var usable_rect: Rect2i = DisplayServer.screen_get_usable_rect(DisplayServer.get_primary_screen())
	new_flower.start_position = Vector2(randf_range(0.0, usable_rect.size.x), -VERTICAL_SIZE)
	add_child(new_flower)
	flowers.append(new_flower)
	new_flower.deleted_flower.connect(_on_deleted_flower)
	
	spawn_timer.wait_time = randf_range(20.0, 40.0)
	spawn_timer.start()
	_update_mouse_passthrough_polygon()


func _update_screen() -> void:
	var usable_rect: Rect2i = DisplayServer.screen_get_usable_rect(DisplayServer.get_primary_screen())
	size = Vector2i(usable_rect.size.x, VERTICAL_SIZE)
	position = Vector2i(usable_rect.position.x, usable_rect.end.y - VERTICAL_SIZE)
	# Update the merge polygon
	merge_polygon.polygon = [
		Vector2(0.0, VERTICAL_SIZE),
		Vector2(usable_rect.size.x, VERTICAL_SIZE),
		Vector2(usable_rect.size.x, VERTICAL_SIZE - 10.0),
	]


func _update_mouse_passthrough_polygon() -> void:
	var final_polygon := merge_polygon.polygon.duplicate()
	for flower: Flower in flowers:
		final_polygon = Geometry2D.merge_polygons(final_polygon, flower.polygon)[0]
	mouse_passthrough_polygon = final_polygon
	debug.polygon = final_polygon


func _on_deleted_flower(flower: Flower) -> void:
	flowers.erase(flower)
	_update_mouse_passthrough_polygon()
