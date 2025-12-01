class_name Flower
extends Area2D


signal deleted_flower(flower: Flower)
signal new_growth_height(height: float)

var start_position: Vector2

@onready var polygon: PackedVector2Array:
	get():
		return stem.polygon

@onready var stem: FlowerStem = $Stem


func _ready() -> void:
	stem.next_height = start_position.y
	stem.path.curve.set_point_position(0, start_position)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	print("Flower interacted with")
	if event.is_action_pressed(&"click"):
		print("Flower clicked")
		deleted_flower.emit(self)
		queue_free()


func _on_stem_new_growth_height() -> void:
	new_growth_height.emit(stem.next_height)


func _on_mouse_entered() -> void:
	print("Mouse entered flower")
