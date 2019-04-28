extends Node2D

const BAR_WIDTH: int = 40
const BAR_HEIGHT: int = 500
const BAR_BORDER: int = 10
const MAX_POINTS: int = 1000

var player_one_value: int = 100
var player_two_value: int = 100

var is_finished: bool = false
var is_border_visible: bool = true

func _ready() -> void:
	position.x = get_viewport_rect().size.x / 2 - (BAR_WIDTH/2)

func show_border():
	is_border_visible = true
	update()

func hide_border():
	is_border_visible = false
	update()

''' value should be int between -100 and 100, player 0 is red and top, player 1 is blue and bottom '''
func modify_player_value(value: int, player: int):
	assert abs(value) <= 100
	
	if player == 0:
		if value <= 0 and player_one_value <= 0:
			player_one_value = 0
			return
		player_one_value += value
	if player == 1:
		if value <= 0 and player_one_value <= 0:
			player_one_value = 0
			return
		player_two_value += value
	
	if player_one_value + player_two_value >= MAX_POINTS:
		is_finished = true
		get_tree().change_scene("res://EndScene.tscn")
	
	update()

func _draw() -> void:

	var player_one_factor = player_one_value * float(BAR_HEIGHT) / MAX_POINTS
	var player_two_factor = player_two_value * float(BAR_HEIGHT) / MAX_POINTS
	
	if is_finished: # draw golden
		draw_rect(Rect2(Vector2(0,0), Vector2(BAR_WIDTH, BAR_HEIGHT + BAR_BORDER*2)),Color("#ffcc00"))
		draw_rect(Rect2(Vector2(BAR_BORDER,BAR_BORDER), Vector2(BAR_BORDER*2, BAR_HEIGHT)),Color("#ffcc00"))
	else: # draw white
		if is_border_visible: # draw border
			draw_rect(Rect2(Vector2(0,0), Vector2(BAR_WIDTH, BAR_HEIGHT + BAR_BORDER*2)),Color(0.7, 0.7, 0.7, 1))
		else:
			draw_rect(Rect2(Vector2(0,0), Vector2(BAR_WIDTH, BAR_HEIGHT + BAR_BORDER*2)),Color("#ffcc00"))
			
		
		draw_rect(Rect2(Vector2(BAR_BORDER,BAR_BORDER), Vector2(BAR_BORDER*2, BAR_HEIGHT)),Color(1, 1, 1, 1))

		# draw points
		draw_rect(Rect2(Vector2(BAR_BORDER,BAR_BORDER), Vector2(BAR_BORDER*2, player_one_factor)),Color("#a6224b"))
		draw_rect(Rect2(Vector2(BAR_BORDER,BAR_HEIGHT+BAR_BORDER-player_two_factor), Vector2(BAR_BORDER*2, player_two_factor)),Color("#3f2aac"))