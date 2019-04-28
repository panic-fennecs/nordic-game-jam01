extends Node2D

var sum = 0.0
var speed = 0.0

func _input(event: InputEvent) -> void:
	print(event)

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_W) and Input.is_key_pressed(KEY_UP):
		speed += 0.1 * delta
	else:
		speed -= 0.1 * delta
	
	speed *= 0.99
	if sum == 0:
		speed = max(speed, 0)
	sum += speed * 0.7
	sum = max(0, sum)
	$icon.rotation_degrees = 360 * sum
	if sum > 1:
		get_tree().change_scene("res://Main.tscn")
	$ColorRect2.modulate.a = sum