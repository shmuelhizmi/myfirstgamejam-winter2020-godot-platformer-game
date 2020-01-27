extends Node2D


func reset_enemies():
	for i in range(0, $enemies.get_child_count()):
    	$enemies.get_child(i).queue_free()
	var enemies = preload("res://objects/scene's/maps/testArea_enemies.tscn").instance()
	$enemies.add_child(enemies);
	pass