extends Node2D

var sum = 0.0
var speed = 0.0
var count = 0

const F = 7;

var bounce_counter = [0, 0];
var buttons = [];
var pressmap = [false, false];
var still_pressed_w = true
var still_pressed_up = true

func _process(delta: float) -> void:
	if !Input.is_key_pressed(KEY_W): still_pressed_w = false
	if !Input.is_key_pressed(KEY_UP): still_pressed_up = false
	
	
	if !still_pressed_w and Input.is_key_pressed(KEY_W) != pressmap[0]:
		pressmap[0] = Input.is_key_pressed(KEY_W);
		if pressmap[0]:
			bounce_counter[0] = 1;
	if !still_pressed_up and Input.is_key_pressed(KEY_UP) != pressmap[1]:
		pressmap[1] = Input.is_key_pressed(KEY_UP);
		if pressmap[1]:
			bounce_counter[1] = 1;

	if !still_pressed_w and !still_pressed_up and Input.is_key_pressed(KEY_W) and Input.is_key_pressed(KEY_UP):
		speed += 0.1 * delta
	else:
		speed -= 0.1 * delta

	$Label.rect_scale = Vector2(1 + sum, 1 + sum)
	$Label.modulate.a = 1 - sum

	speed *= 0.99
	if sum == 0:
		speed = max(speed, 0)
	sum += speed * 0.7
	sum = max(0, sum)
	if sum > 1:
		count += 1
		$Label.rect_scale = Vector2(1, 1)
		$Label.modulate.a = 1
		sum = 0
		speed = 0.0
		if count == 1:
			still_pressed_w = true
			still_pressed_up = true
			$Label.text = "Get enough sleep and food before\nyou get in touch with other people." 
		if count == 2:
			still_pressed_w = true
			still_pressed_up = true
			$Label.text = "Try to cooperate with your partner\nto finally break out of the loop."
		if count == 3:
			$Sprite.position.y += 150
			$Sprite2.position.y += 150
			$Label2.rect_position.y += 150
			$Label.set_visible(false)
			$Description.set_visible(true)
			still_pressed_w = true
			still_pressed_up = true
			$Label2.text = "Get ready"
		if count == 4:
			get_tree().change_scene("res://Main.tscn")
	$ColorRect2.modulate.a = sum

	for x in [0, 1]:
		if bounce_counter[x] > 0:
			buttons[x].scale = Vector2(1, 1) * (1.0 + (float(F)/2 - abs(bounce_counter[x] - float(F)/2)) / 8.0);
			bounce_counter[x] += 1
		if bounce_counter[x] >= 10:
			bounce_counter[x] = 0;
			buttons[x].scale = Vector2(1, 1);

func _ready():
	buttons.append($Sprite)
	buttons.append($Sprite2)