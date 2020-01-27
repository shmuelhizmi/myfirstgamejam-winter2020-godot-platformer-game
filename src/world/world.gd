extends Node2D


func reset_enemies():
	$enemies.get_tree().reload_current_scene();
	pass