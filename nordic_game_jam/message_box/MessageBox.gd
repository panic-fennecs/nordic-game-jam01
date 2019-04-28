extends Node2D

func show_text(text):
	$Label.text = text
	$Label.set_visible(true)
	$Timer.connect("timeout", self, "on_timeout")
	$Timer.start()

func on_timeout():
	$Label.set_visible(false)