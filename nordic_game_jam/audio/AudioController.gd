extends AudioStreamPlayer

# music is 130 bpm

var music_party = preload("res://audio/music_party.ogg")
var music_party_lowpass = preload("res://audio/music_party_lowpass.ogg")
var music_bedroom = preload("res://audio/music_bedroom.ogg")

var player_party = AudioStreamPlayer.new()
var player_party_lowpass = AudioStreamPlayer.new()
var player_bedroom = AudioStreamPlayer.new()

func _ready():
	music_party.set_loop(true)
	
	player_party.stream = music_party
	# player_music_party.volume_db = -12
	add_child(player_party)
	
	player_party.play()

func _process(delta):
	pass

# index | scene
# 0 | sleeping in bedroom
# 1 | eating in kitchen
# 2 | dancing at party
func _on_scene_changed(index):
	player_party.stop()
	player_party.play()

func _on_day_over():
	_on_scene_changed(0)
