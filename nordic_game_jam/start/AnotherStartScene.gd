extends Node2D

var sum = 0.0
var count = 0

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_W) and Input.is_key_pressed(KEY_UP):
		sum += delta * 0.5
		$Label.rect_scale = Vector2(1 + sum, 1 + sum)
		$Label.modulate.a = 1 - sum
		if sum > 1:
			count += 1
			$Label.rect_scale = Vector2(1, 1)
			$Label.modulate.a = 1
			sum = 0
			if count == 1:
				$Label.text = "Get enough sleep and food before\nyou get in touch with other people." 
			if count == 2:
				$Label.text = "Try to cooperate with your partner\nto finally break out of the loop."
			if count == 3:
				get_tree().change_scene("res://Main.tscn")
	else:
		sum = 0
		$Label.rect_scale = Vector2(1, 1)
		$Label.modulate.a = 1