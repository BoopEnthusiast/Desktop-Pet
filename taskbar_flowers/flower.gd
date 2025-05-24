class_name Flower
extends TextureButton


const FLOWERS_ATLAST_TEXTURE = preload("res://taskbar_flowers/art/flowers_atlast_texture.tres")

var texture: AtlasTexture


func _ready() -> void:
	texture = FLOWERS_ATLAST_TEXTURE.duplicate()
	texture.region.position.x = randi_range(0, 9) * 100
	flip_h = [true, false].pick_random()
	texture_normal = texture


func _on_pressed() -> void:
	queue_free()
