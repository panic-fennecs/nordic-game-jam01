extends Node2D

func _ready():
	$Timer.connect("timeout", self, "on_timeout")

func show_text(text):
	$Label.text = text
	$Label.set_visible(true)
	$Timer.start()

func on_timeout():
	$Label.set_visible(false)