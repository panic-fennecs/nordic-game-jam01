extends Node2D

const emote_scene = preload("res://character/Emote.tscn")

func _ready() -> void:
	pass
	
#func _input(event: InputEvent) -> void:
#	if event.is_action_pressed("ui_accept"):
#		spawn_emote("miss")
	
func spawn_emote(emote_type: String) -> void:
	var emote = emote_scene.instance()
	emote.set_emote_type(emote_type)
	emote.position = $EmoteSpawnPoint.position
	add_child(emote)