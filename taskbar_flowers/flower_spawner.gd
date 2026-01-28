class_name FlowerSpawner
extends Timer


signal new_flower_made(new_flower: Flower)

const FLOWER = preload("uid://cdsgvyubp0tfp")

@onready var main: TaskbarFlowers = $".."


func _on_timeout() -> void:
	var new_flower: Flower = FLOWER.instantiate()
	new_flower.start_position = randf_range(5.0, float(main.size.x) - 5.0)
	new_flower.curve.set_point_position(0, Vector2(new_flower.start_position, 0.0))
	new_flower.position = Vector2.DOWN * main.size.y
	
	new_flower_made.emit(new_flower)
	
	start(randf_range(5.0, 30.0))
