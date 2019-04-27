extends Node2D

onready var im = get_node("/root/Main/InputManagerNode")
onready var bm = get_node("/root/Main/UILayer/ButtonManagerNode")

func generate_random(n, start_timestamp, possible_keys):
	var inst = load("res://patterns/Pattern.gd")
	return inst.generate_random(n, start_timestamp, null, 1000, possible_keys);

func on_gain_focus():
	var pattern = generate_random(1, 0, ["up", "left", "right", "down"]);
	bm.prepare_pattern("0", pattern); # TODO player 1
	im.clear()

func on_lose_focus():
	pass