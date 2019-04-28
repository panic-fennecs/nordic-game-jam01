extends Sprite

const _miss_texture = preload("res://res/images/emotes/emote_wrong.png")
const _love_texture = preload("res://res/images/emotes/emote_like.png")
const _tasty_texture = preload("res://res/images/emotes/emote_eat.png")
const _rested_texture = preload("res://res/images/emotes/emote_sleep.png")


var initial_pos: Vector2
var is_miss: bool = false

func _ready() -> void:
	initial_pos = position + Vector2(rand_range(-20,20), rand_range(-20,20))
	$Timer.connect("timeout", self, "_on_Timer_timeout")
	if is_miss:
		$Timer.wait_time = 0.4
		$Tween.interpolate_property(self, "position", initial_pos, 
			initial_pos + Vector2(0, -100), 0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		$Tween.start()
	$Timer.start()

func _process(delta: float) -> void:
	if not is_miss:
		var new_x: float = sin($Timer.time_left * 10) * 60
		var new_y: float = -200 * (($Timer.wait_time - $Timer.time_left) / $Timer.wait_time)
		position = initial_pos + Vector2(new_x, new_y)
		self.modulate.a = 1 - (($Timer.wait_time - $Timer.time_left) / $Timer.wait_time)
	
func set_emote_type(emote_type: String) -> void:
	match emote_type:
		"miss":
			texture = _miss_texture
			is_miss = true
		"love":
			texture = _love_texture
		"tasty":
			texture = _tasty_texture
		"rested":
			texture = _rested_texture
		
	scale = Vector2(0.5, 0.5)
	
func _on_Timer_timeout():
	queue_free()