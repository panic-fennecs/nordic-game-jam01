extends Camera2D

onready var tween 

func _unhandled_key_input(event):
	if event.pressed and event.scancode == KEY_3:
		move_to_next_scene()
		
func move_to_next_scene():
	self.set_position(Vector2(0, self.position.y + 1080))