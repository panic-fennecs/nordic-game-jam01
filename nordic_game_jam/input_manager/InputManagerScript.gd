extends Node

const POSSIBLE_INPUTS = [
	KEY_Q, KEY_P
];

var inputs = [];

func get_current_time():
	return OS.get_ticks_usec();

func _input(ev):
	if ev is InputEventKey and ev.scancode in POSSIBLE_INPUTS and ev.pressed and !ev.echo:
		inputs.append([get_current_time(), ev.scancode]);