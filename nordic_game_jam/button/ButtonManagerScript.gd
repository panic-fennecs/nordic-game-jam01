extends Node2D

onready var im = get_node("/root/Main/InputManagerNode");
var BUTTON = preload("res://button/Button.tscn");
const PREP_DELTA = 600;

var preps = {};
var buttons = {};

func to_id(player, key):
	player = str(player)
	return "p" + player + "_" + key;

func from_id(string):
	var a = string.split("_")[0];
	var b = string.split("_")[1];
	a = a.substr(1, a.len() - 1);
	return [a, b];

func dist_x(x):
	if x == "left":
		return -1
	elif x == "down":
		return 0
	elif x == "up":
		return 0
	elif x == "right":
		return 1
	assert(false)

func dist_y(x):
	if x == "left":
		return 0
	elif x == "down":
		return 1
	elif x == "up":
		return -1
	elif x == "right":
		return 0
	assert(false)
	

func _ready():
	for player in ["0", "1"]:
		for key in ["up", "down", "left", "right"]:
			var button = BUTTON.instance();
			var id = to_id(player, key);
			button.play(id);

			var dim = get_viewport_rect().size;

			var screenx = dim.x;
			var screeny = dim.y;
			var button_size = 128;

			var posx = screenx / 4 + dist_x(key) * button_size * 1.5;
			if player == "1":
				posx += screenx / 2;
			
			var posy = screeny / 2 + dist_y(key) * button_size * 1.5;

			button.position.x = posx;
			button.position.y = posy;
			buttons[id] = button;
			preps[id] = [];
			add_child(button);

func prepare_key(player, key, time):
	preps[to_id(player, key)].append(time);

func prepare_pattern(player, pattern):
	for hit in pattern.hits:
		prepare_key(player, hit.key, hit.timestamp);

func clear_preps():
	preps = {};
	for player in ["0", "1"]:
		for key in ["up", "down", "left", "right"]:
			preps[to_id(player, key)] = [];

func _process(_delta):
	var ct = im.get_current_time();
	for i in preps:
		var max_sizefactor = 0
		for x in preps[i]:
			var sizefactor = null
			if ct > x:
				sizefactor = 1;
			elif ct < x - PREP_DELTA:
				sizefactor = 0;
			else: 
				sizefactor = 1 - (float(x - ct) / PREP_DELTA);

			max_sizefactor = max(max_sizefactor, sizefactor)
		buttons[i].get_child(0).scale = Vector2(max_sizefactor, max_sizefactor);
