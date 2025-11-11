extends Module


@onready var passthrough_polygon: Polygon2D = $"Passthrough Polygon"


func _ready() -> void:
	mouse_passthrough_polygon = passthrough_polygon.polygon 
