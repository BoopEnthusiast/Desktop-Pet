class_name TaskbarFlowers
extends Module


const FLOWER = preload("res://taskbar_flowers/flower.tscn")
const VERTICAL_SIZE = 100

var flowers: Array[Flower]

@onready var spawn_timer: Timer = $SpawnTimer
@onready var merge_polygon: Polygon2D = $MergePolygon


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
	add_child(new_flower)
	flowers.append(new_flower)
	new_flower.deleted_flower.connect(_on_deleted_flower)
	var usable_rect: Rect2i = DisplayServer.screen_get_usable_rect(DisplayServer.get_primary_screen())
	new_flower.position.x = randf_range(0.0, usable_rect.size.x)
	spawn_timer.wait_time = randf_range(0.0, 20.0)
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
		Vector2(usable_rect.size.x, VERTICAL_SIZE - 0.1),
	]


func _update_mouse_passthrough_polygon() -> void:
	var final_polygon := merge_polygon.polygon
	for flower: Flower in flowers:
		var flower_rect = flower.get_rect()
		var flower_polygon: PackedVector2Array = [
			flower_rect.position,
			flower_rect.position + Vector2(flower_rect.size.x, 0.0),
			flower_rect.position + flower_rect.size,
			flower_rect.position + Vector2(0.0, flower_rect.size.y),
		]
		final_polygon = Geometry2D.merge_polygons(final_polygon, flower_polygon)[0]
	mouse_passthrough_polygon = final_polygon


func _on_deleted_flower(flower: Flower) -> void:
	flowers.erase(flower)
	_update_mouse_passthrough_polygon()
