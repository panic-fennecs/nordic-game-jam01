extends Node2D

func _ready():
	$MainTimer.connect("timeout", self, "on_main_timeout")
	$SubTimer.connect("timeout", self, "on_sub_timeout")

func show_main_text(text):
	$MainLabel.text = text
	$MainLabel.set_visible(true)
	$MainTimer.start()

func show_sub_text(text):
	$SubLabel.text = text
	$SubLabel.set_visible(true)
	$SubTimer.start()

func on_main_timeout():
	$MainLabel.set_visible(false)

func on_sub_timeout():
	$SubLabel.set_visible(false)

func reset():
	$MainLabel.set_visible(false)
	$SubLabel.set_visible(false)