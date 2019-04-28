extends Node2D

const emote_scene = preload("res://character/Emote.tscn")
	
func spawn_emote(emote_type: String) -> void:
	var emote = emote_scene.instance()
	emote.set_emote_type(emote_type)
	emote.position = $EmoteSpawnPoint.position
	add_child(emote)