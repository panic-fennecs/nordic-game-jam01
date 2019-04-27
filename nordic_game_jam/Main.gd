extends Node2D

export var iteration = 3

var scene_list = []

func _ready():
	$UILayer/Clock.connect("day_over", self, "day_over_signal_received")
	preload_scenes()
	instantiate_scenes_current_iteration()
	
func preload_scenes():
	var sleep_scene_resource = load("res://sleep/SleepScene.tscn")
	scene_list.append(sleep_scene_resource)
	
func instantiate_scenes_current_iteration():
	#test loop for instantiating multiple scenes
	for i in range(0, iteration):
		instantiate_next_scene(i)
		
	iteration+=1
	
func instantiate_next_scene(index):
	var next_scene = scene_list[0].instance()
	next_scene.set_position(Vector2(0, index * 720))
	add_child(next_scene)
	next_scene.add_to_group("dynamic_scenes")
	
func day_over_signal_received():
	$Camera2D.scroll_to_new_day()
	remove_old_scenes()
	instantiate_scenes_current_iteration()
	
func remove_old_scenes():
	var dynamic_scenes = get_tree().get_nodes_in_group("dynamic_scenes")
	for scene in dynamic_scenes:
		scene.queue_free()
