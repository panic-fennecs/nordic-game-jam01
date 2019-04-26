extends Node2D


const PLAYER1_KEY = KEY_A
const PLAYER2_KEY = KEY_L


onready var player1_node = get_node("Player1_pressed")
onready var player2_node = get_node("Player2_pressed")


func _ready():
	player1_node.play("unpressed")
	player2_node.play("unpressed")


func _input(event):
	if event is InputEventKey:
		var player = null
		if event.scancode == PLAYER1_KEY:
			player = player1_node
		elif event.scancode == PLAYER2_KEY:
			player = player2_node
		else:
			return

		var new_anim = null
		if event.is_pressed():
			if not event.is_echo():
				new_anim = "pressed"
			else:
				return
		else:
			new_anim = "unpressed"

		player.play(new_anim)