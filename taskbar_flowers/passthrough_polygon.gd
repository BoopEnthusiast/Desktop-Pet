class_name PassthroughPolygon
extends Node


var _current_task_id: int = -12345

var _poly: PackedVector2Array
var _flowers: Array # Array[Dictionary] is &"points": Array[float], &"width": float
var _height: float

@onready var _main: TaskbarFlowers = $".."
#@onready var _debug: Polygon2D = $Debug


func _exit_tree() -> void:
	WorkerThreadPool.wait_for_task_completion(_current_task_id)


func start_passthrough_update() -> void:
	if get_tree().get_frame() % 200 != 0:
		return
	#print(get_tree().get_frame(),"\t\t",WorkerThreadPool.is_task_completed(_current_task_id),"\t",_current_task_id)
	if _current_task_id == -12345:
		start_worker_thread()
	elif WorkerThreadPool.is_task_completed(_current_task_id):
		WorkerThreadPool.wait_for_task_completion(_current_task_id)
		start_worker_thread()


func start_worker_thread() -> void:
	_poly = _main.merge_polygon.duplicate()
	_flowers = _main.flowers
	#.map(func (f: Flower):
			#var final_dict: Dictionary
			#final_dict[&"width"] = f.width
			#final_dict[&"points"] = f.points.duplicate()
			#return final_dict
	#).filter(func (d: Dictionary):
			#if d == null:
				#return false
			#elif d[&"points"].size() > 0:
				#return true
			#else:
				#return false
	#)
	_height = _main.height
	update_passthrough_polygon()
	#_current_task_id = WorkerThreadPool.add_task(update_passthrough_polygon)


func update_passthrough_polygon() -> void:
	#for flower: Dictionary in _flowers:
	_main.grow_flower_mutex.lock()
	for flower: Flower in _flowers:
		flower.can_grow_mutex.lock()
		#var flower_poly := Geometry2D.offset_polyline(flower[&"points"], flower[&"width"] / 2, Geometry2D.JOIN_ROUND, Geometry2D.END_ROUND)[0]
		var flower_poly := Geometry2D.offset_polyline(flower.points, flower.width / 2, Geometry2D.JOIN_ROUND, Geometry2D.END_ROUND)[0]
		flower.can_grow_mutex.unlock()
		_poly = Geometry2D.merge_polygons(_poly, flower_poly)[0]
		flower.can_grow_mutex.unlock()
	_main.grow_flower_mutex.unlock()
	
	_poly = _poly * Transform2D(0.0, Vector2.UP * _height)
	
	_main.set_deferred(&"mouse_passthrough_polygon", _poly)
	#_debug.set_deferred(&"polygon", _poly)
