extends Node

const POSSIBLE_INPUTS = [
	"ui_select"
];

var inputs = [];

func get_current_time():
	return OS.get_ticks_usec();

func has_been_pressed(string):
	return Input.is_action_just_pressed(string);

func store_inputs():
	for pi in POSSIBLE_INPUTS:
		if has_been_pressed(pi):
			inputs.append([get_current_time(), pi]);

func _process(delta):
	store_inputs();
	print(inputs);