extends Node2D

signal start_game()

func _ready():
	pass

func _draw() -> void:
	var size = Vector2(1280, 720)
	var top_left = Vector2(0, 0)
	draw_rect(Rect2(top_left, size), Color(0.1, 0.11, 0.12, 1))

func _physics_process(delta):
	position.y = -720 - $"/root/Main/Camera2D".transform.get_origin().y
	update()

func close():
	emit_signal("start_game")