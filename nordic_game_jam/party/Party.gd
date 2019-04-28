extends Node2D


onready var input_manager = get_node("/root/Main/InputManagerNode")
onready var bm = get_node("/root/Main/UILayer/ButtonManagerNode")
onready var message_box = get_node("/root/Main/UILayer/MessageBox")

var last_input1 = 0
var last_input2 = 0
var last_key1 = null
var last_key2 = null
var first_hides = true

var player1_forbidden = []
var player2_forbidden = []

var disabled = false

const THRESHOLD = 60
const DEBUFF_VALUE = -30
const BUFF_VALUE = 60

var active = false


func _ready():
	get_node("Character1/AnimationPlayer").play("dance")
	get_node("Character2/AnimationPlayer").play("rave")
	get_node("Character2").set_scale(Vector2(-0.5, 0.5))
	$UnhideTimer.connect("timeout", self, "unhide_buttons")
	$RehideTimer.connect("timeout", self, "new_forbidden")


func reset_player_inputs():
	last_input1 = 0
	last_key1 = null
	last_input2 = 0
	last_key2 = null


func choose_and_remove(arr):
	var v = arr[randi() % len(arr)]
	arr.erase(v)
	return v

func new_forbidden():
	if first_hides:
		first_hides = false
		message_box.show_main_text("except...")
	generate_forbidden()
	hide_forbidden()
	disabled = false

func generate_forbidden():
	var possible = ["left", "right", "up", "down"]
	player1_forbidden.clear()
	player2_forbidden.clear()

	var value0 = choose_and_remove(possible)
	player1_forbidden.append(value0)
	player2_forbidden.append(value0)

	var value1 = choose_and_remove(possible)
	player1_forbidden.append(value1)

	var value2 = choose_and_remove(possible)
	player2_forbidden.append(value2)


func hide_forbidden():
	var keys = []
	for i in player1_forbidden:
		keys.append(bm.to_id(0, i))
	for i in player2_forbidden:
		keys.append(bm.to_id(1, i))

	for k in keys:
		bm.buttons[k].show_bomb(true)

	$UnhideTimer.start()


func next_round():
	$RehideTimer.start()
	disabled = true


func unhide_buttons():
	for b in bm.buttons.values():
		b.show_bomb(false)



func on_gain_focus():
	active = true
	reset_player_inputs()
	message_box.show_main_text("Press the same key together.")
	get_node("/root/Main/UILayer/AffectionBar").hide_border()
	get_node("Character1/Bottle").set_visible(false)
	get_node("Character2/Bottle").set_visible(false)

func on_lose_focus():
	active = false
	unhide_buttons()
	get_node("/root/Main/UILayer/AffectionBar").show_border()

func miss(player_num):
	reset_player_inputs()
	if player_num == 0:
		$Character1.spawn_emote("miss")
		$Character2.spawn_emote("miss")
	elif player_num == 1:
		$Character1.spawn_emote("miss")
	else:
		$Character2.spawn_emote("miss")

	get_node("/root/Main/UILayer/AffectionBar").modify_player_value(DEBUFF_VALUE, 0)
	get_node("/root/Main/UILayer/AffectionBar").modify_player_value(DEBUFF_VALUE, 1)

	next_round()


func strike(key):
	reset_player_inputs()

	var forb = false
	if (key in player1_forbidden):
		message_box.show_sub_text("Could not use this Key (player 1)")
		$Character1.spawn_emote("miss")
		forb = true
		bm.buttons[bm.to_id(0, key)].show_bomb_timed()
	if (key in player2_forbidden):
		message_box.show_sub_text("Could not use this Key (player 2)")
		$Character2.spawn_emote("miss")
		forb = true
		bm.buttons[bm.to_id(1, key)].show_bomb_timed()

	if not forb:
		$Character1.spawn_emote("love")
		$Character2.spawn_emote("love")

		get_node("/root/Main/UILayer/AffectionBar").modify_player_value(BUFF_VALUE, 0)
		get_node("/root/Main/UILayer/AffectionBar").modify_player_value(BUFF_VALUE, 1)

		bm.buttons[bm.to_id(0, key)].succeed()
		bm.buttons[bm.to_id(1, key)].succeed()
	else:
		get_node("/root/Main/UILayer/AffectionBar").modify_player_value(DEBUFF_VALUE, 0)
		get_node("/root/Main/UILayer/AffectionBar").modify_player_value(DEBUFF_VALUE, 1)

	next_round()

func _process(_delta):
	if (not active):
		return

	var current_time = get_current_time()

	if (last_input1 != 0) and (last_input2 != 0):
		var diff = abs(last_input1 - last_input2)
		if diff > THRESHOLD:
			bm.buttons[bm.to_id(0, last_key1)].failed()
			bm.buttons[bm.to_id(1, last_key2)].failed()
			miss(0)
		else:
			if last_key1 != last_key2:
				message_box.show_main_text("Press the same key")
				bm.buttons[bm.to_id(0, last_key1)].failed()
				bm.buttons[bm.to_id(1, last_key2)].failed()
				miss(0)

			else:
				strike(last_key1)

	if last_input1 != 0:
		var diff1 = abs(current_time - last_input1)
		if diff1 > THRESHOLD:
			bm.buttons[bm.to_id(0, last_key1)].failed()
			miss(1)


	if last_input2 != 0:
		var diff2 = abs(current_time - last_input2)
		if diff2 > THRESHOLD:
			bm.buttons[bm.to_id(1, last_key2)].failed()
			miss(2)


func _input(event):
	if (not active) or disabled:
		return

	var current_time = get_current_time()
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.scancode in input_manager.PLAYER0_INPUTS:
				last_input1 = current_time
				last_key1 = input_manager.PLAYER0_INPUTS[event.scancode]
			elif event.scancode in input_manager.PLAYER1_INPUTS:
				last_input2 = current_time
				last_key2 = input_manager.PLAYER1_INPUTS[event.scancode]


func get_current_time():
	return OS.get_ticks_msec();