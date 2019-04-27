extends Node

const PLAYER1_INPUTS = {
	KEY_W: "up",
	KEY_A: "left",
	KEY_D: "right",
	KEY_S: "down",
};

const PLAYER2_INPUTS = {
	KEY_UP: "up",
	KEY_LEFT: "left",
	KEY_RIGHT: "right",
	KEY_DOWN: "down",
};

var player1_inputs = [];
var player2_inputs = [];

func get_current_time():
	return OS.get_ticks_msec();

func _input(ev):
	var ct = get_current_time();
	if ev is InputEventKey and ev.pressed and !ev.echo:
		if ev.scancode in PLAYER1_INPUTS:
			var entry = {"time": ct, "input": PLAYER1_INPUTS[ev.scancode]};
			player1_inputs.append(entry);
		if ev.scancode in PLAYER2_INPUTS:
			var entry = {"time": ct, "input": PLAYER2_INPUTS[ev.scancode]};
			player2_inputs.append(entry);

func clear():
	player1_inputs.clear()
	player2_inputs.clear()