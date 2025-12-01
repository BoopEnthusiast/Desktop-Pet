class_name FlowerStem
extends CollisionPolygon2D


signal new_growth_height()

var next_height: float = 0.0

var _velocity: Vector2 = Vector2.UP
var _acceleration: Vector2 = Vector2.UP

var _current_task_id: int = -12345
var _points: PackedVector2Array

@onready var path: Path2D = $StemPath
@onready var line: Line2D = $StemLine


func _ready() -> void:
	path.curve = path.curve.duplicate()


func _process(delta: float) -> void:
	_grow_path(delta)
	line.points = path.curve.get_baked_points()


func _physics_process(_delta: float) -> void:
	if _current_task_id == -12345:
		_start_worker_thread()
	elif WorkerThreadPool.is_task_completed(_current_task_id):
		WorkerThreadPool.wait_for_task_completion(_current_task_id)
		_start_worker_thread()


func _grow_path(delta: float) -> void:
	var active_point_index: int = path.curve.point_count - 1
	var active_point: Vector2 = path.curve.get_point_position(active_point_index)
	if active_point.y < next_height:
		next_height -= randf_range(10.0, 20.0)
		_acceleration = Vector2.from_angle(randf_range(0.0, TAU)) * 2.0
		path.curve.add_point(active_point)
		_grow_path(delta)
		new_growth_height.emit()
		return
	
	_acceleration = _acceleration.move_toward(Vector2(randf_range(-1.0, 1.0), randf_range(-2.0, 1.0)), delta)
	_velocity += (_acceleration * delta).clampf(-10.0, 5.0)
	path.curve.set_point_in(active_point_index, -_velocity)
	path.curve.set_point_in(active_point_index, _velocity)
	path.curve.set_point_position(active_point_index, active_point + _velocity * delta)


func _start_worker_thread() -> void:
	_points = line.points.duplicate()
	_current_task_id = WorkerThreadPool.add_task(_update_collider)


func _update_collider() -> void:
	var reversed_points := _points.duplicate()
	for i: int in range(_points.size()):
		_points[i] += Vector2.LEFT * (line.width)
		reversed_points[i] += Vector2.RIGHT * (line.width)
	reversed_points.reverse()
	_points.append_array(reversed_points)
	set_deferred(&"polygon", _points)
