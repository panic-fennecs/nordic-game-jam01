extends Node2D

signal day_over

const CLOCK_BACKGROUND_COLOR = Color(1.0, 1.0, 1.0)
const CLOCK_OUTLINE_COLOR = Color(0.0, 0.0, 0.0)
const CLOCK_PROGRESS_COLOR = Color(1.0, 0.0, 0.0)

func _ready() -> void:
	$FreeTimeTimer.connect("timeout", self, "_day_over")
	
func _day_over() -> void:
	emit_signal("day_over")
	
func _process(delta: float) -> void:
	update()
	
func _draw() -> void:
	var center: Vector2 = Vector2(0, 0)
	var radius: int = 80
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
	    var angle_point: float = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
	    points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)