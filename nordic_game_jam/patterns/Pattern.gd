extends Node

class_name Pattern

const TIMESTEP_INTERVAL = 500

class Hit:
	func _init(k, t):
		self.key = k
		self.timestamp = t

	var key
	var timestamp

var hits = []

func _init(h):
	self.hits = h

static func choose(arr):
	return arr[randi() % len(arr)]

static func get_next_timestamp(start_timestamp):
	var current_time = get_current_time()
	assert start_timestamp < current_time
	var diff = current_time - start_timestamp
	var next_timestamp = current_time - (diff % TIMESTEP_INTERVAL) + 2*TIMESTEP_INTERVAL
	return next_timestamp

static func generate_random(n, start_timestamp, possible_keys):
	var inst = load("res://patterns/Pattern.gd")
	
	if possible_keys == null:
		possible_keys = ["right", "left", "down", "up"]

	var random_hits = []
	for i in range(n):
		var key = choose(possible_keys)
		var timestamp = get_next_timestamp(start_timestamp) + i * TIMESTEP_INTERVAL
		random_hits.append(Hit.new(key, timestamp))
	return inst.new(random_hits)

static func get_current_time():
	return OS.get_ticks_msec();