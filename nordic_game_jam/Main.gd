extends Node2D

var scene_index = 0
var day_index = 0

var scene_list_prefabs = []

func _unhandled_key_input(event):
	if event.pressed and event.scancode == KEY_3:
		next_scene()

func get_scenes():
	return get_tree().get_nodes_in_group("dynamic_scenes")

func _ready():
	$UILayer/Clock.connect("day_over", self, "day_over_signal_received")
	preload_scenes()
	instantiate_scenes_current_iteration()
	init_scene()
	
func preload_scenes():
	var sleep_scene_resource = load("res://sleep/SleepScene.tscn")
	scene_list_prefabs.append(sleep_scene_resource)
	
func instantiate_scenes_current_iteration():
	#test loop for instantiating multiple scenes
	for i in range(0, 3):
		instantiate_next_scene(i)
	
func instantiate_next_scene(index):
	var next_scene = scene_list_prefabs[0].instance()
	next_scene.set_position(Vector2(0, index * 720))
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

func day_over_signal_received():
	get_scenes()[scene_index].on_lose_focus()
	day_index += 1
	scene_index = 0
	init_scene()
	remove_old_scenes()
	instantiate_scenes_current_iteration()
	
func remove_old_scenes():
	for scene in get_scenes():
		scene.queue_free()
		remove_child(scene)

func _on_room_changed(index):
	pass # Replace with function body.
