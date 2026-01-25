class_name Flower
extends Line2D


@export var curve: Curve2D

var start_position: float
var next_goal_height: float = 0.0

var _velocity: Vector2 = Vector2.UP
var _acceleration: Vector2 = Vector2.UP

@onready var debug_line: Polygon2D = $DebugLine
@onready var debug_path: Path2D = $DebugPath


func _enter_tree() -> void:
	curve = curve.duplicate()


func _ready() -> void:
	debug_path.curve = curve


func _process(delta: float) -> void:
	_grow_path(delta)
	
	points = curve.get_baked_points()
	#debug_line.polygon = Geometry2D.offset_polyline(curve.get_baked_points(), width / 2, Geometry2D.JOIN_ROUND, Geometry2D.END_ROUND)[0]


func _grow_path(delta: float) -> void:
	var active_point_index: int = curve.point_count - 1
	var active_point: Vector2 = curve.get_point_position(active_point_index)
	if active_point.y < next_goal_height:
		next_goal_height -= randf_range(10.0, 40.0)
		_acceleration = Vector2.from_angle(randf_range(0.0, TAU)) * 2.0
		curve.add_point(active_point)
		_grow_path(delta)
		return
	
	_acceleration = _acceleration.move_toward(Vector2(randf_range(-1.0, 1.0), randf_range(-2.0, 1.0)), delta)
	_velocity += (_acceleration * delta).clampf(-10.0, 5.0)
	curve.set_point_in(active_point_index, -_velocity * 3.0)
	curve.set_point_in(active_point_index, _velocity * 3.0)
	curve.set_point_position(active_point_index, active_point + _velocity * delta)


func get_closest_point(global_pos: Vector2) -> Vector2:
	return to_global(curve.get_closest_point(to_local(global_pos)))
