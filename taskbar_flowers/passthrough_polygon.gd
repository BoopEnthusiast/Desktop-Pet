class_name PassthroughPolygon
extends Node


var _current_task_id: int = -12345

var _poly: PackedVector2Array
var _flowers: Array # Array[Dictionary] is &"points": Array[float], &"width": float
var _height: float

@onready var _main: TaskbarFlowers = $".."
#@onready var _debug: Polygon2D = $Debug


func _exit_tree() -> void:
	pass#WorkerThreadPool.wait_for_task_completion(_current_task_id)


func start_passthrough_update() -> void:
	if _current_task_id == -12345:
		_start_worker_thread()
	elif WorkerThreadPool.is_task_completed(_current_task_id):
		WorkerThreadPool.wait_for_task_completion(_current_task_id)
		_start_worker_thread()


func _start_worker_thread() -> void:
	_poly = _main.merge_polygon.duplicate()
	_flowers = _main.flowers.map(func (f: Flower):
			var final_dict: Dictionary
			final_dict[&"width"] = f.width
			print(f.points)
			final_dict[&"points"] = f.points.duplicate()
			return final_dict
	).filter(func (d: Dictionary):
			if d == null:
				return false
			if d[&"points"].size() > 0:
				return true
			else:
				return false
	)
	_height = _main.height
	_update_passthrough_polygon()
	#_current_task_id = WorkerThreadPool.add_task(_update_passthrough_polygon)


func _update_passthrough_polygon() -> void:
	for flower: Dictionary in _flowers:
		print("Flower: ",flower[&"width"],"  ",flower[&"points"])
		var flower_poly := Geometry2D.offset_polyline(flower[&"points"], flower[&"width"] / 2, Geometry2D.JOIN_ROUND, Geometry2D.END_ROUND)[0]
		var polys := Geometry2D.merge_polygons(_poly, flower_poly)
		_poly = polys[0]
	
	_poly = _poly * Transform2D(0.0, Vector2.UP * _height)
	
	_main.set_deferred(&"mouse_passthrough_polygon", _poly)
	#_debug.set_deferred(&"polygon", _poly)
