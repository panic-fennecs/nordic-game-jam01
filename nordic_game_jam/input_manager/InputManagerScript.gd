extends Node

onready var bm = get_node("/root/Main/UILayer/ButtonManagerNode")

const F = 7;

const PLAYER0_INPUTS = {
	KEY_W: "up",
	KEY_A: "left",
	KEY_D: "right",
	KEY_S: "down",
};

const PLAYER1_INPUTS = {
	KEY_UP: "up",
	KEY_LEFT: "left",
	KEY_RIGHT: "right",
	KEY_DOWN: "down",
};

var SCANCODES = PLAYER0_INPUTS.keys() + PLAYER1_INPUTS.keys()

var player0_inputs = [];
var player1_inputs = [];

var button_bounce_counter = {};

func _ready():
	for x in ["up", "left", "right", "down"]:
		for p in ["0", "1"]:
			var id = bm.to_id(p, x)
			button_bounce_counter[id] = 0;

func get_current_time():
	return OS.get_ticks_msec();

func _input(ev):
	var ct = get_current_time();
	if ev is InputEventKey and ev.pressed and !ev.echo and ev.scancode in SCANCODES:
		var input = null
		var p = null
		if ev.scancode in PLAYER0_INPUTS:
			input = PLAYER0_INPUTS[ev.scancode]
			p = 0
			var entry = {"time": ct, "input": input};
			player0_inputs.append(entry);
		if ev.scancode in PLAYER1_INPUTS:
			p = 1
			input = PLAYER1_INPUTS[ev.scancode]
			var entry = {"time": ct, "input": input};
			player1_inputs.append(entry);
		var id = bm.to_id(p, input);
		button_bounce_counter[id] = 1;
		

func clear():
	player0_inputs.clear()
	player1_inputs.clear()

func get_inputs(x):
	x = str(x);
	if x == "0": return player0_inputs
	elif x == "1": return player1_inputs
	assert(false)

func _process(_delta):
	for x in ["up", "left", "right", "down"]:
		for p in ["0", "1"]:
			var id = bm.to_id(p, x)
			if button_bounce_counter[id] > 0:
				bm.buttons[id].scale = Vector2(1, 1) * (1.0 + (float(F)/2 - abs(button_bounce_counter[id] - float(F)/2)) / 8.0);
				button_bounce_counter[id] += 1
			if button_bounce_counter[id] >= 10:
				button_bounce_counter[id] = 0;
				bm.buttons[id].scale = Vector2(1, 1);
			