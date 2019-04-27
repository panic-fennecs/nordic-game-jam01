extends Node2D

func generate_random(n, start_timestamp, possible_keys):
	var inst = load("res://patterns/Pattern.gd")
	return inst.generate_random(n, start_timestamp, null, 0, possible_keys);

func _ready():
	var bm = get_node("/root/Main/UILayer/ButtonManagerNode")
	var pattern = generate_random(1, 0, ["up", "left", "right", "down"]);
	bm.prepare_pattern("0", pattern); # TODO player 1