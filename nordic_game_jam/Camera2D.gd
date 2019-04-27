extends Camera2D

func _unhandled_key_input(event):
	if event.pressed and event.scancode == KEY_3:
		move_to_next_scene()

func move_to_next_scene():
	$Tween.interpolate_property(self, "position", self.position, 
		self.position + Vector2(0, 1080), 1, 
		Tween.TRANS_CIRC, Tween.EASE_OUT)
	$Tween.start()
	
func scroll_to_new_day():
	$Tween.interpolate_property(self, "position", self.position, 
		Vector2(0, 0), 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()