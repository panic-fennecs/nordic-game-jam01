extends Node2D

var sum = 0.0

func _input(event: InputEvent) -> void:
	print(event)

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_W) and Input.is_key_pressed(KEY_UP):
		sum += delta * 0.5
		$icon.rotation_degrees = 360 * sum
		if sum > 1:
			get_tree().change_scene("res://Main.tscn")
	else:
		sum = 0
		$icon.rotation_degrees = 360 * sum		
		
	$ColorRect2.modulate.a = sum