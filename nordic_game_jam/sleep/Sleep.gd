extends Node2D

onready var im = get_node("/root/Main/InputManagerNode")
onready var bm = get_node("/root/Main/UILayer/ButtonManagerNode")

const MAX_NOTE_DIST = 20;
const THRESHOLD = 150;

var pattern = null;

func generate_random(n, start_timestamp, possible_keys):
	var inst = load("res://patterns/Pattern.gd")
	return inst.generate_random(n, start_timestamp, null, 1000, possible_keys);

func restart():
	bm.clear_preps();
	pattern = generate_random(2, 0, ["up", "left", "right", "down"]);
	bm.prepare_pattern("0", pattern); # TODO player 1
	im.clear()

func on_gain_focus():
	restart()

func on_lose_focus():
	pattern = null;
	bm.clear_preps();

func fail():
	print("fail!")
	restart()

func win():
	print("win!")
	im.clear();
	pattern = null;
	bm.clear_preps();

func _process(_delta):
	if pattern == null: return
	var i = im.get_inputs(0);
	if len(i) > 0:
		if i[0].input != pattern.hits[0].key:
			print("wrong key!")
			fail();
			return
		if abs(i[0].time - pattern.hits[0].timestamp) >= THRESHOLD:
			print(i[0].time, " ", pattern.hits[0].timestamp)
			print("thresh!")
			fail();
			return
		bm.preps[bm.to_id("0", i[0].input)].pop_front();
		i.pop_front();
		pattern.hits.pop_front();
		print("small win")
		if len(pattern.hits) == 0:
			win();