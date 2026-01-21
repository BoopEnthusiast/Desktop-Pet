class_name TaskbarFlowers
extends Module


var flowers: Array[Flower]
var tallest_flower: Flower

var merge_polygon: PackedVector2Array
var height: float

@onready var flower_spawner: FlowerSpawner = $FlowerSpawner
@onready var merge_polygon_node: Polygon2D = $MergePolygon
@onready var passthrough_polygon: PassthroughPolygon = $PassthroughPolygon


func _on_new_flower_made(new_flower: Flower) -> void:
	add_child(new_flower)
	new_flower.new_growth_height.connect(_on_flower_new_growth_height)
	flowers.append(new_flower)


func _on_flower_new_growth_height(flower: Flower) -> void:
	if flower == tallest_flower or not is_instance_valid(tallest_flower) or flower.next_goal_height < tallest_flower.next_goal_height:
		tallest_flower = flower
		_update_window()
	passthrough_polygon.start_passthrough_update()


func _update_window() -> void:
	
	# Update the window
	var usable_rect: Rect2i = DisplayServer.screen_get_usable_rect(DisplayServer.get_primary_screen())
	
	if usable_rect.size != size:
		# Move flowers
		for flower: Flower in flowers:
			flower.position.y = size.y
	
	size = usable_rect.size
	
	if not is_node_ready():
		await ready
	
	# Update the merge polygon
	merge_polygon = [
		Vector2(0.0, 0.0),
		Vector2(0.0, -1.0),
		Vector2(usable_rect.size.x, -1.0),
		Vector2(usable_rect.size.x, 0.0),
	]
	merge_polygon_node.polygon = merge_polygon
	height = size.y
	
	# TODO: remove all newly out-of-bounds flowers and make flowers not want to go out of bounds


func _on_close_requested() -> void:
	# TODO: emit some deletion signal or something and delete it from the loaded module list, probably best to do this in the parent class, 
	# also, make the parent Module class abstract maybe
	queue_free()
