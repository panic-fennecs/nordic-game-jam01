extends AnimatedSprite

func _ready():
	$RedTimer.connect("timeout", self, "_on_unfail_timeout")
	$GreenTimer.connect("timeout", self, "_on_unsuccess_timeout")

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