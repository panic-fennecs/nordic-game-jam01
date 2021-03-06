extends Node2D

const CLOCK_BACKGROUND_COLOR = Color(1.0, 1.0, 1.0)
const CLOCK_OUTLINE_COLOR = Color(0.0, 0.0, 0.0)
const CLOCK_PROGRESS_COLOR = Color(1.0, 0.0, 0.0)

onready var audio_player = get_node("/root/Main/AudioStreamPlayer")

func _ready() -> void:
	$FreeTimeTimer.connect("timeout", self, "on_day_over")
	position.x = get_viewport_rect().size.x / 2
	
func on_day_over() -> void:
	audio_player.play_rewind()
	get_node("/root/Main").on_day_over()

func _process(_delta: float) -> void:
	update()
	
func _draw() -> void:
	var center: Vector2 = Vector2(0, 0)
	var radius: int = 64
	var angle_from: int = 0
	var angle_to: float = 360 - (360 * ($FreeTimeTimer.time_left / $FreeTimeTimer.wait_time))
	draw_circle(center, radius + 8, CLOCK_OUTLINE_COLOR)
	draw_circle(center, radius, CLOCK_BACKGROUND_COLOR)
	draw_circle_arc_poly(center, radius, angle_from, angle_to, CLOCK_PROGRESS_COLOR)
	draw_circle(center, 8, CLOCK_OUTLINE_COLOR)
	draw_circle(center + Vector2(radius - 2, 0), 8, CLOCK_OUTLINE_COLOR)
	draw_circle(center - Vector2(radius - 2, 0), 8, CLOCK_OUTLINE_COLOR)
	draw_circle(center + Vector2(0, radius - 2), 8, CLOCK_OUTLINE_COLOR)
	draw_circle(center - Vector2(0, radius - 2), 8, CLOCK_OUTLINE_COLOR)

func draw_circle_arc_poly(center: Vector2, radius: int, angle_from: int, angle_to: int, color: Color) -> void:
	var nb_points: int = 512
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])
	
	for i in range(nb_points + 1):
	    var angle_point: float = deg2rad(angle_from + i * float(angle_to - angle_from) / nb_points - 90)
	    points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)
