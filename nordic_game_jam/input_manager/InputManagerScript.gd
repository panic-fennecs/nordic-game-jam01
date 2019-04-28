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
	var introduction = get_tree().get_root().get_node("Main/UILayer/Introduction")
	var is_running = get_tree().get_root().get_node("Main").is_running
	
	var ct = get_current_time();
	if ev is InputEventKey and ev.pressed and !ev.echo:
		if ev.scancode in PLAYER1_INPUTS:
			if is_running:
				var entry = {"time": ct, "input": PLAYER1_INPUTS[ev.scancode]};
				player1_inputs.append(entry);
			else:
				introduction.close()
		if ev.scancode in PLAYER2_INPUTS:
			if is_running:
				var entry = {"time": ct, "input": PLAYER2_INPUTS[ev.scancode]};
				player2_inputs.append(entry);
			else:
				introduction.close()

func clear():
	player1_inputs.clear()
	player2_inputs.clear()

func get_inputs(x):
	x = str(x);
	if x == "0": return player1_inputs
	elif x == "1": return player2_inputs
	assert(false)