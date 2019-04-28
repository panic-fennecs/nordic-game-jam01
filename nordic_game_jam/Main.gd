extends Node2D

var scene_index = 0
var day_index = 0
var player_0_hair
var player_1_hair

var scene_list_prefabs = [
	load("res://sleep/SleepScene.tscn"),
	load("res://eat/EatScene.tscn"),
	load("res://party/PartyScene.tscn")
];


var hairs = [
	load("res://res/images/stick_head.png"),
	load("res://res/images/stick_head_2.png")
]

func _unhandled_key_input(event):
	if event.pressed and event.scancode == KEY_3:
		next_scene()

func get_scenes():
	return get_tree().get_nodes_in_group("dynamic_scenes")

func _ready():
	randomize()
	player_0_hair = hairs[randi() % hairs.size()]
	player_1_hair = hairs[randi() % hairs.size()]
	instantiate_scenes()
	init_scene()
	

func instantiate_scenes():
	#test loop for instantiating multiple scenes
	for i in range(0, len(scene_list_prefabs)):
		var next_scene = scene_list_prefabs[i].instance()
		next_scene.set_position(Vector2(0, i * 720))
		add_child(next_scene)
		next_scene.add_to_group("dynamic_scenes")

func init_scene():
	get_tree().get_nodes_in_group("dynamic_scenes")[scene_index].on_gain_focus()
	$Camera2D.move_to_scene(scene_index)

func next_scene():
	get_tree().get_nodes_in_group("dynamic_scenes")[scene_index].on_lose_focus()
	if scene_index == len(get_scenes())-1:
		day_index += 1
		scene_index = 0
	else:
		scene_index += 1
	init_scene()
	get_node("/root/Main/AudioController")._on_room_changed(scene_index)

func on_day_over():
	get_scenes()[scene_index].on_lose_focus()
	day_index += 1
	scene_index = 0
	remove_old_scenes()
	instantiate_scenes()
	init_scene()
	get_node("/root/Main/AudioController")._on_room_changed(scene_index)

func remove_old_scenes():
	for scene in get_scenes():
		scene.queue_free()
		remove_child(scene)