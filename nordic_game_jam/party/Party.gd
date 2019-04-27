extends Node2D


onready var input_manager = get_node("/root/Main/InputManagerNode")
onready var bm = get_node("/root/Main/UILayer/ButtonManagerNode")

var last_input1 = 0
var last_input2 = 0

var num_current_matches = 0
const NUM_MATCHES = 5

const THRESHOLD = 40000

var active = false


func _ready():
	get_node("Character1/AnimationPlayer").play("dance")
	get_node("Character2/AnimationPlayer").play("dance")


func on_gain_focus():
	active = true
	bm.set_visible(false)
	num_current_matches = 0
	last_input1 = 0
	last_input2 = 0

func on_lose_focus():
	active = false
	bm.set_visible(true)

func miss(player_num):
	num_current_matches = 0
	last_input1 = 0
	last_input2 = 0
	print("miss")
	if player_num == 0:
		$Character1.spawn_emote("miss")
		$Character2.spawn_emote("rested")
	elif player_num == 1:
		$Character1.spawn_emote("miss")
	else:
		$Character2.spawn_emote("miss")


func strike():
	num_current_matches += 1
	print(num_current_matches)
	$Character1.spawn_emote("love")
	$Character2.spawn_emote("love")
	last_input1 = 0
	last_input2 = 0
	if num_current_matches >= NUM_MATCHES:
		get_node("/root/Main").next_scene()

func _process(_delta):
	if not active:
		return

	var current_time = get_current_time()

	if (last_input1 != 0) and (last_input2 != 0):
		var diff = abs(last_input1 - last_input2)
		if diff > THRESHOLD:
			miss(0)
		else:
			strike()

	if last_input1 != 0:
		var diff1 = abs(current_time - last_input1)
		if diff1 > THRESHOLD:
			miss(1)

	if last_input2 != 0:
		var diff2 = abs(current_time - last_input2)
		if diff2 > THRESHOLD:
			miss(2)


func _input(event):
	if not active:
		return

	var current_time = get_current_time()
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.scancode in input_manager.PLAYER1_INPUTS:
				last_input1 = current_time
			elif event.scancode in input_manager.PLAYER2_INPUTS:
				last_input2 = current_time


func get_current_time():
	return OS.get_ticks_usec();