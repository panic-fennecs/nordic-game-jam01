extends Node2D


const PLAYER1_KEY = KEY_A
const PLAYER2_KEY = KEY_L


onready var player1_node = get_node("Player1_pressed")
onready var player2_node = get_node("Player2_pressed")


var last_input1 = 0
var last_input2 = 0

var num_current_matches = 0

const THRESHOLD = 40000


func _ready():
	player1_node.play("unpressed")
	player2_node.play("unpressed")


func _process(_delta):
	var current_time = get_current_time()

	if (last_input1 != 0) and (last_input2 != 0):
		var diff = abs(last_input1 - last_input2)
		if diff > THRESHOLD:
			print("bup0")
		else:
			print("yup")
		last_input1 = 0
		last_input2 = 0

	if last_input1 != 0:
		var diff1 = abs(current_time - last_input1)
		if diff1 > THRESHOLD:
			last_input1 = 0
			last_input2 = 0
			print("bup1")

	if last_input2 != 0:
		var diff2 = abs(current_time - last_input2)
		if diff2 > THRESHOLD:
			last_input1 = 0
			last_input2 = 0
			print("bup2")

func _input(event):
	var current_time = get_current_time()
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.scancode == PLAYER1_KEY:
				player1_node.play("pressed")
				last_input1 = current_time
			elif event.scancode == PLAYER2_KEY:
				player2_node.play("pressed")
				last_input2 = current_time
		elif not event.pressed:
			if event.scancode == PLAYER1_KEY:
				player1_node.play("unpressed")
			elif event.scancode == PLAYER2_KEY:
				player2_node.play("unpressed")


func get_current_time():
	return OS.get_ticks_usec();