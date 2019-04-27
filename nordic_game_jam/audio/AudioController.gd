extends AudioStreamPlayer

# music is 130 bpm

var initialized = false

var music_party = preload("res://audio/music_party.ogg")
var music_party_lowpass = preload("res://audio/music_party_lowpass.ogg")
var music_bedroom = preload("res://audio/music_bedroom.ogg")

var player_party = AudioStreamPlayer.new()
var player_party_lowpass = AudioStreamPlayer.new()
var player_bedroom = AudioStreamPlayer.new()
var players = [player_bedroom, player_party_lowpass, player_party]

const fading_speed = 2
var fading = false
var fading_value = 0
var index = 0
var prev_index = 0

const db_low_threshold = -25
const db_high_threshold = 0

func _init():
	music_party.set_loop(true)
	music_party_lowpass.set_loop(true)
	music_bedroom.set_loop(true)
	
	player_party.stream = music_party
	player_party_lowpass.stream = music_party_lowpass
	player_bedroom.stream = music_bedroom
	add_child(player_party)
	add_child(player_party_lowpass)
	add_child(player_bedroom)
	
	#_init_with_room(0)

func _process(delta):
	if fading:
		fade(fading_speed * delta)

func _init_with_room(index):
	initialized = true
	
	for player in players:
		player.volume_db = db_low_threshold
		
	players[index].volume_db = 1
	self.index = index
	prev_index = (index + 1) % players.size() # set it to some other value
	players[index].play()

func fade(amount):
	fading_value = min(1, fading_value + amount)
	
	# fade volume
	players[prev_index].volume_db = fading_value * db_low_threshold
	players[index].volume_db = (1 - fading_value) * db_low_threshold
	
	if fading_value == 1:
		stop_fading()

func start_fading(new_index):
	print("start_fading ", index, " -> ", new_index)
	if fading: # fix volume if already fading
		players[prev_index].volume_db = db_low_threshold
	prev_index = index
	index = new_index
	fading = true
	fading_value = 0
	players[new_index].play()

func stop_fading():
	print("stop_fading ", prev_index, " -> ", index)
	fading = false
	fading_value = 0
	players[prev_index].stop()

func stop_players():
	player_party.stop()
	player_party_lowpass.stop()
	player_bedroom.stop()

# index | scene
# 0 | sleeping in bedroom
# 1 | eating in kitchen
# 2 | dancing at party
func _on_room_changed(new_index):
	if !initialized:
		_init_with_room(new_index)
	elif new_index != index: # only fade when room is different
		start_fading(new_index)
