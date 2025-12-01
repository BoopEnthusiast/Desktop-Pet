class_name TaskbarFlowersOld
extends Module


const FLOWER = preload("res://taskbar_flowers/flower.tscn")
const STARTING_VERTICAL_SIZE = 100

@export var transform_array: Transform2D:
	set(value):
		debug.polygon = debug.polygon * value
		transform_array = value

var tallest_flower: FlowerOld
var flowers: Array[FlowerOld]

@onready var spawn_timer: Timer = $SpawnTimer
@onready var merge_polygon: Polygon2D = $MergePolygon
@onready var debug: Polygon2D = $Debug


func _on_close_requested() -> void:
	visible = false


func _on_spawn_timer_timeout() -> void:
	var new_flower: FlowerOld = FLOWER.instantiate()
	var usable_rect: Rect2i = DisplayServer.screen_get_usable_rect(DisplayServer.get_primary_screen())
	new_flower.start_position.x = randf_range(10.0, usable_rect.size.x - 10)
	new_flower.position.y = size.y
	add_child(new_flower)
	flowers.append(new_flower)
	new_flower.deleted_flower.connect(_on_deleted_flower)
	new_flower.new_growth_height.connect(_on_flower_new_growth_height)
	
	spawn_timer.wait_time = randf_range(20.0, 40.0)
	spawn_timer.start()
	_update_mouse_passthrough_polygon()


func _update_screen() -> void:
	var usable_rect: Rect2i = DisplayServer.screen_get_usable_rect(DisplayServer.get_primary_screen())
	size = Vector2i(usable_rect.size.x, STARTING_VERTICAL_SIZE)
	position = Vector2i(usable_rect.position.x, usable_rect.end.y - STARTING_VERTICAL_SIZE)
	
	# Update the merge polygon
	if not is_node_ready():
		await ready
	merge_polygon.polygon = [
		Vector2(0.0, size.y),
		Vector2(usable_rect.size.x, size.y),
		Vector2(usable_rect.size.x, size.y - 1.0),
	]


func _update_mouse_passthrough_polygon() -> void:
	var final_polygon := merge_polygon.polygon.duplicate()
	# Move initial 3 point polygon up
	for i: int in range(final_polygon.size()):
		final_polygon[i] = Vector2(final_polygon[i].x, final_polygon[i].y - size.y)
	
	# Merge polygons
	for flower: FlowerOld in flowers:
		var merged_polygons = Geometry2D.merge_polygons(final_polygon, flower.polygon)
		final_polygon = merged_polygons[0]
	
	# Move polygon back down
	for i: int in range(final_polygon.size()):
		final_polygon[i] = Vector2(final_polygon[i].x, final_polygon[i].y + size.y)
	mouse_passthrough_polygon = final_polygon
	debug.polygon = final_polygon


func _on_flower_new_growth_height(height: float) -> void:
	if height >= size.y:
		size.y += 10
	for flower: FlowerOld in flowers:
		flower.position.y = size.y
	print("New height: ", size.y)


func _on_deleted_flower(flower: FlowerOld) -> void:
	flowers.erase(flower)
	_update_mouse_passthrough_polygon()
