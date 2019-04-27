extends Node

class_name Pattern

const DEFAULT_TIMESTEP_INTERVAL = 500

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

static func get_next_timestamp(start_timestamp, timestep_interval, time_offset):
	var target_time = get_current_time() + time_offset
	assert start_timestamp < target_time
	var diff = target_time - start_timestamp
	var next_timestamp = target_time - (diff%timestep_interval) + 2*timestep_interval
	return next_timestamp

static func generate_random(n, start_timestamp, timestep_interval, time_offset, possible_keys):
	var inst = load("res://patterns/Pattern.gd")
	
	if timestep_interval == null:
		timestep_interval = DEFAULT_TIMESTEP_INTERVAL

	if possible_keys == null:
		possible_keys = ["right", "left", "down", "up"]

	var random_hits = []
	for i in range(n):
		var key = choose(possible_keys)
		var timestamp = get_next_timestamp(start_timestamp, timestep_interval, time_offset) + i * timestep_interval
		random_hits.append(Hit.new(key, timestamp))
	return inst.new(random_hits)

static func get_current_time():
	return OS.get_ticks_msec();