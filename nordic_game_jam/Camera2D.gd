extends Camera2D

func move_to_scene(i):
	$Tween.interpolate_property(self, "position", self.position, 
		Vector2(0, i * 720), 1, 
		Tween.TRANS_CIRC, Tween.EASE_OUT)
	$Tween.start()