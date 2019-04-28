extends Node2D

func _ready():
	$MainTimer.connect("timeout", self, "on_main_timeout")
	$SubTimer.connect("timeout", self, "on_sub_timeout")

func show_main_text(text):
	$MainLabelLeft.text = text
	$MainLabelRight.text = text
	$MainLabelLeft.set_visible(true)
	$MainLabelRight.set_visible(true)
	# $MainTimer.start()

func show_sub_text(text):
	$SubLabelLeft.text = text
	$SubLabelRight.text = text
	$SubLabelLeft.set_visible(true)
	$SubLabelRight.set_visible(true)
	$SubTimer.start()

func on_main_timeout():
	$MainLabelLeft.set_visible(false)
	$MainLabelRight.set_visible(false)

func on_sub_timeout():
	$SubLabelLeft.set_visible(false)
	$SubLabelRight.set_visible(false)

func reset():
	$MainLabelLeft.set_visible(false)
	$MainLabelRight.set_visible(false)
	$SubLabelLeft.set_visible(false)
	$SubLabelRight.set_visible(false)