extends Camera2D

func move_to_scene(i):
	var tween_func = Tween.TRANS_BOUNCE if i == 0 else Tween.TRANS_CIRC
	var tween_duration = 1.5 if i == 0 else 1
	
	$Tween.interpolate_property(self, "position", self.position, 
		Vector2(0, i * 720), tween_duration, 
		tween_func, Tween.EASE_OUT)
	$Tween.start()