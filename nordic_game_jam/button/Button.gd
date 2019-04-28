extends AnimatedSprite

func _ready():
	$RedTimer.connect("timeout", self, "_on_unfail_timeout")
	$GreenTimer.connect("timeout", self, "_on_unsuccess_timeout")
	$BombTimer.connect("timeout", self, "_on_bomb_hide")

func failed():
	$RedBack.set_visible(true)
	$RedTimer.start()

func succeed():
	$GreenBack.set_visible(true)
	$GreenTimer.start()

func _on_unfail_timeout():
	$RedBack.set_visible(false)

func _on_unsuccess_timeout():
	$GreenBack.set_visible(false)

func show_bomb(v):
	$Bomb.set_visible(v)
	if v:
		self.self_modulate = Color(255, 255, 255, 0)
	else:
		self.self_modulate = Color(255, 255, 255, 255)
	$BlackBack.set_visible(not v)

func show_bomb_timed():
	show_bomb(true)
	$BombTimer.start()

func _on_bomb_hide():
	show_bomb(false)