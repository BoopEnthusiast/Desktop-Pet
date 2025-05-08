class_name Sprite
extends AnimatedSprite2D


var has_idled: int = 0

@onready var blink: Timer = $Blink
@onready var idle: Timer = $Idle


func _on_blink_timeout() -> void:
	blink.wait_time += randf_range(-2.0, 2.0)
	blink.wait_time = clampf(blink.wait_time, 2.0, 10.0)
	if frame == 0:
		play("blink")


func _on_idle_timeout() -> void:
	idle.wait_time = randf_range(10, 120)
	if randf() > 0.5:
		play("idle")
		flip_h = true
		has_idled = 2
	else:
		play("idle")
		has_idled = 1


func _on_animation_finished() -> void:
	flip_h = false
	if has_idled == 1:
		play("idle")
		flip_h = true
		has_idled = 0
	elif has_idled == 2:
		play("idle")
		has_idled = 0
	else:
		play("default")
