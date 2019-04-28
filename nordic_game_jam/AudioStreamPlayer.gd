extends AudioStreamPlayer

var success_sound = preload("res://audio/sfx_good.ogg")
var failed_sound = preload("res://audio/sfx_bad.ogg")
var rewind_sound = preload("res://audio/rewind.ogg")

var players = []

func _physics_process(delta):
	for p in players:
		if not p.is_playing():
			players.erase(p)
			p.queue_free()
			break

func playStream(pathToFile):
	var player = AudioStreamPlayer.new()
	pathToFile.set_loop(false)
	player.stream = pathToFile
	add_child(player)
	player.play()

	players.append(player)

func play_success():
	playStream(success_sound)

func play_failed():
	playStream(failed_sound)

func play_rewind():
	playStream(rewind_sound)
