extends Node2D

var sum = 0.0
var speed = 0.0

const F = 7;

var bounce_counter = [0, 0];
var buttons = [];
var pressmap = [false, false];

func _ready():
	buttons.append($Sprite)
	buttons.append($Sprite2)

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_W) != pressmap[0]:
		pressmap[0] = Input.is_key_pressed(KEY_W);
		if pressmap[0]:
			bounce_counter[0] = 1;
	if Input.is_key_pressed(KEY_UP) != pressmap[1]:
		pressmap[1] = Input.is_key_pressed(KEY_UP);
		if pressmap[1]:
			bounce_counter[1] = 1;

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
		get_tree().change_scene("res://start/AnotherStartScene.tscn")
	$ColorRect2.modulate.a = sum

	for x in [0, 1]:
		if bounce_counter[x] > 0:
			buttons[x].scale = Vector2(1, 1) * (1.0 + (float(F)/2 - abs(bounce_counter[x] - float(F)/2)) / 8.0);
			bounce_counter[x] += 1
		if bounce_counter[x] >= 10:
			bounce_counter[x] = 0;
			buttons[x].scale = Vector2(1, 1);