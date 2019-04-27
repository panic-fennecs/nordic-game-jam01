extends Node2D

onready var im = get_node("/root/Main/InputManagerNode");
var BUTTON = preload("res://button/Button.tscn");
const PREP_DELTA = 400;

var preps = {};
var buttons = {};

func to_id(player, key):
	return "p" + player + "_" + key;

func from_id(string):
	var a = string.split("_")[0];
	var b = string.split("_")[1];
	a = a.substr(1, a.len() - 1);
	return [a, b];

func _init():
	for player in ["0", "1"]:
		for key in ["up", "down", "left", "right"]:
			var button = BUTTON.instance();
			var id = to_id(player, key);
			button.play(id);

			var dim = OS.get_screen_size();

			var screenx = dim.x;
			var screeny = dim.y;
			var button_size = 64;

			var posx = screenx / 4;
			if player == "1":
				posx += screenx / 2;
			if key == "left":
				posx -= button_size * 2;
			if key == "right":
				posx += button_size * 2;
			
			var posy = screeny - button_size * 2;
			if key == "up": posy -= button_size * 2;

			button.position.x = posx;
			button.position.y = posy;
			buttons[id] = button;
			preps[id] = null;
			add_child(button);
	prepare_key("0", "left", 2000);

func prepare_key(player, key, time):
	preps[to_id(player, key)] = time;

func prepare_pattern(player, pattern):
	for hit in pattern.hits:
		prepare_key(player, hit.key, hit.timestamp);

func _process(_delta):
	var ct = im.get_current_time();
	for i in preps:
		var x = preps[i];
		var sizefactor = 0;
		if x != null:
			sizefactor = (ct - x) / PREP_DELTA;
			if sizefactor > 1:
				sizefactor = 1;
			if sizefactor < 0:
				sizefactor = 0;
		buttons[i].get_child(0).scale.y = sizefactor;