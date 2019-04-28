extends Node2D

func _on_TimeoutTimer_timeout():
	get_tree().change_scene("res://start/StartScene.tscn")