extends Node2D


const PLAYER1_KEY = KEY_A
const PLAYER2_KEY = KEY_L


# onready var player1_node = get_node("Player1_pressed")
# onready var player2_node = get_node("Player2_pressed")
onready var input_manager = get_node("/root/Main/InputManagerNode")
onready var character1 = get_node("/root/Main/Character1")
onready var character2 = get_node("/root/Main/Character2")


var last_input1 = 0
var last_input2 = 0

var num_current_matches = 0
const NUM_MATCHES = 5

const THRESHOLD = 40000

var active = false


func on_gain_focus():
	active = true

func on_lose_focus():
	active = false

func miss(player_num):
	num_current_matches = 0
	last_input1 = 0
	last_input2 = 0
	print("miss")
	if player_num == 0:
		character1.spawn_emote("miss")
		character2.spawn_emote("rested")
	elif player_num == 1:
		character1.spawn_emote("miss")
	else:
		character2.spawn_emote("miss")


func strike():
	num_current_matches += 1
	print(num_current_matches)
	character1.spawn_emote("love")
	character2.spawn_emote("love")
	last_input1 = 0
	last_input2 = 0
	if num_current_matches >= NUM_MATCHES:
		print("won")

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
			if event.scancode == PLAYER1_KEY:
				# player1_node.play("pressed")
				last_input1 = current_time
			elif event.scancode == PLAYER2_KEY:
				# player2_node.play("pressed")
				last_input2 = current_time
		# elif not event.pressed:
			# if event.scancode == PLAYER1_KEY:
				# player1_node.play("unpressed")
			# elif event.scancode == PLAYER2_KEY:
				# player2_node.play("unpressed")


func get_current_time():
	return OS.get_ticks_usec();
