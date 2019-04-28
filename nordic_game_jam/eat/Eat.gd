extends Node2D

onready var im = get_node("/root/Main/InputManagerNode")
onready var bm = get_node("/root/Main/UILayer/ButtonManagerNode")
onready var sprite_prefab = load("eat/Marker.tscn")

const BLACKLIST_THRESHOLD = 200;
const BLACKLIST_LEN = 10;
const THRESHOLD = 100;

var blacklist = []
var current_pattern = []
var waiting_for_player = null
var active = false
var pattern_visuals = []

func restart():
	current_pattern = []
	waiting_for_player = null
	for x in pattern_visuals:
		x.queue_free()
	pattern_visuals = []

func on_gain_focus():
	info("play the same melody!")
	active = true
	restart()

func on_lose_focus():
	active = false

func info(x):
	get_node("/root/Main/UILayer/MessageBox").show_text(x)

func blacklisted(pattern):
	for p in blacklist:
		if len(p) != len(pattern):
			continue
		var similar = true
		for i in range(len(p)):
			if p[i].input != pattern[i].input:
				similar = false
				break
			if abs((p[i].time - p[0].time) - (pattern[i].time - pattern[0].time)) >= BLACKLIST_THRESHOLD:
				similar = false
				break
		if similar:
			return true
		
	return false

func _process(_delta):
	if not active: return

	if waiting_for_player == null:
		for p in [0, 1]:
			var i = im.get_inputs(p)
			if len(i) > 0:
				var x = i.pop_front();
				current_pattern.append({"input": x.input, "time": im.get_current_time()})
				waiting_for_player = 1 - p
				var visu = sprite_prefab.instance();
				visu.position = Vector2(80 + len(pattern_visuals) * 80, 80);
				visu.play(x.input);
				pattern_visuals.append(visu);
				add_child(visu);
				return
	else:
		if len(im.get_inputs(1 - waiting_for_player)) > 0:
			info("didn't react!")
			restart()
			return
		var i = im.get_inputs(waiting_for_player)
		if len(i) > 0:
			var x = i.pop_front();
			if current_pattern.back().input != x.input:
				info("wrong key!")
				restart()
				return
			else:
				info("good!")
				waiting_for_player = null
				if len(current_pattern) >= 4:
					if blacklisted(current_pattern):
						info("not that again!")
						restart()
						return
					else:
						blacklist.append(current_pattern)
						if len(blacklist) > BLACKLIST_LEN:
							blacklist.pop_front();
						info("nice!")
						get_node("/root/Main").next_scene()
						return
		elif current_pattern.back().time < im.get_current_time() - THRESHOLD:
			info("timeout!")
			restart()
			return






