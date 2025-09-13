class_name FlowerStem
extends CollisionPolygon2D


var next_height: float = 0.0

var _velocity: Vector2 = Vector2.UP
var _acceleration: Vector2 = Vector2.UP

@onready var path: Path2D = $StemPath
@onready var line: Line2D = $StemLine


func _ready() -> void:
	path.curve = path.curve.duplicate()


func _process(delta: float) -> void:
	grow_stem(delta)


func grow_stem(delta: float) -> void:
	_grow_path(delta)
	_update_line()
	_update_collider()


func _grow_path(delta: float) -> void:
	var curve: Curve2D = path.curve
	var active_point_index: int = curve.point_count - 1
	var active_point: Vector2 = curve.get_point_position(active_point_index)
	if active_point.y <= next_height:
		next_height -= randf_range(10.0, 20.0)
		_acceleration = Vector2.from_angle(randf_range(0.0, TAU)) * 2.0
		curve.add_point(active_point)
		_grow_path(delta)
		return
	
	_acceleration = _acceleration.move_toward(Vector2(randf_range(-1.0, 1.0), randf_range(-2.0, 1.0)), delta)
	_velocity += (_acceleration * delta).clampf(-10.0, 5.0)
	curve.set_point_in(active_point_index, -_velocity)
	curve.set_point_in(active_point_index, _velocity)
	curve.set_point_position(active_point_index, active_point + _velocity * delta)


func _update_line() -> void:
	line.points = path.curve.get_baked_points()


func _update_collider() -> void:
	var points := line.points.duplicate()
	var reversed_points := points.duplicate()
	for i: int in range(points.size()):
		points[i] += Vector2.LEFT * (line.width)
		reversed_points[i] += Vector2.RIGHT * (line.width)
	reversed_points.reverse()
	points.append_array(reversed_points)
	polygon = points
