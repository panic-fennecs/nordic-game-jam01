extends Node2D

export var is_player_0: bool = false

const emote_scene = preload("res://character/Emote.tscn")

func _ready() -> void:
	var main = get_node("/root/Main")
	$Body/Head.texture = main.player_0_hair if is_player_0 else main.player_1_hair

func spawn_emote(emote_type: String) -> void:
	var emote = emote_scene.instance()
	emote.set_emote_type(emote_type)
	emote.position = $EmoteSpawnPoint.position
	add_child(emote)