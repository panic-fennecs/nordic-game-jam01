extends Node2D

export var iteration = 3

var scene_list = []

func _ready():
	preload_scenes()
	instantiate_scenes_current_iteration(iteration)
	
func preload_scenes():
	var eat_scene_resource = load("res://eat_scene/EatScene.tscn")
	scene_list.append(eat_scene_resource)
	
func instantiate_scenes_current_iteration(iteration):
	#test loop for instantiating multiple scenes
	for i in range(0, iteration):
		instantiate_next_scene(i)
		
	iteration+=1
		
func instantiate_next_scene(index):
	var next_scene = scene_list[0].instance()
	next_scene.set_position(Vector2(0, index * 1080))
	add_child(next_scene)
