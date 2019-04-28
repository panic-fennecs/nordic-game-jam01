extends Camera2D

func move_to_scene(i, tutorial = false):
	print(tutorial)
	var tween_func = Tween.TRANS_BOUNCE if i == 0 and !tutorial else Tween.TRANS_CIRC
	var tween_duration = 1.5 if i == 0 and !tutorial else 1
	
	$Tween.interpolate_property(self, "position", self.position, 
		Vector2(0, i * 720), tween_duration, 
		tween_func, Tween.EASE_OUT)
	$Tween.start()

func on_game_started():
	pass # Replace with function body.
