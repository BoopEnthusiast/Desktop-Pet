class_name TaskbarFlowers
extends Module


var flowers: Array[Flower]
var tallest_flower: Flower

var previous_size: Vector2i

var merge_polygon: PackedVector2Array
var height: float

@onready var flower_spawner: FlowerSpawner = $FlowerSpawner
@onready var merge_polygon_node: Polygon2D = $MergePolygon
@onready var passthrough_polygon: PassthroughPolygon = $PassthroughPolygon


func _on_new_flower_made(new_flower: Flower) -> void:
	add_child(new_flower)
	flowers.append(new_flower)


func update_window() -> void:
	super()
	
	if previous_size != size:
		# Move flowers
		for flower: Flower in flowers:
			flower.position.y = size.y
	
	previous_size = size
	
	if not is_node_ready():
		await ready
	
	passthrough_polygon.start_passthrough_update()
	
	# Update the merge polygon
	merge_polygon = [
		Vector2(0.0, 0.0),
		Vector2(0.0, -1.0),
		Vector2(size.x, -1.0),
		Vector2(size.x, 0.0),
	]
	merge_polygon_node.polygon = merge_polygon
	height = size.y
	
	# TODO: remove all newly out-of-bounds flowers and make flowers not want to go out of bounds
	# TODO instead: move flowers according to how large the screen is, so if the screen gets smaller it squishes them in


func _on_close_requested() -> void:
	# TODO: emit some deletion signal or something and delete it from the loaded module list, probably best to do this in the parent class, 
	# also, make the parent Module class abstract maybe
	queue_free()
