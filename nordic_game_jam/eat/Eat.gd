extends Node2D

onready var im = get_node("/root/Main/InputManagerNode")
onready var bm = get_node("/root/Main/UILayer/ButtonManagerNode")

const STOP_TIME = 1000;
const THRESHOLD = 300;
const BLACKLIST_LEN = 10;

var blacklist = []
var composer = 0
var state = "compose"
var current_pattern = []
var current_full_pattern = null
var active = false

func restart():
	randomize()
	composer = 0 # randi() % 2 # TODO
	current_pattern = []
	current_full_pattern = []
	state = "compose"

func on_gain_focus():
	active = true
	restart()

func on_lose_focus():
	active = false

func info(x):
	print("info: ", x)

func blacklisted(pattern):
	return false

func _process(_delta):
	if not active: return

	if state == "compose":
		var i = im.get_inputs(composer)
		if len(i) > 0:
			var first = i.pop_front();
			current_pattern.append(first)
			print("note added!")
		elif len(current_pattern) > 0 and current_pattern.back().time < im.get_current_time() - STOP_TIME:
			if blacklisted(current_pattern):
				info("not that again!")
				restart()
				return
			print("repeat now!")
			state = "repeat"
			current_full_pattern = current_pattern.duplicate(true)
	elif state == "repeat":
		var i = im.get_inputs(1 - composer)
		if len(i) > 0:
			var first = i.pop_front();
			if current_pattern[0].input != first.input:
				info("wrong note!")
				restart()
				return
			if abs(current_pattern[0].time - first.time) > THRESHOLD:
				info("too far away!")
				restart()
				return
			current_pattern.pop_front();
			if len(current_pattern) == 0:
				blacklist.append(current_full_pattern);
				if len(blacklist) > BLACKLIST_LEN:
					blacklist.pop_front(); 
				info("nice!")
				get_node("/root/Main").next_scene()
				return