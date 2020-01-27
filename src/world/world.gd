extends Node2D

onready var enemies = $enemies

func _ready():
	get_tree().paused = false

func reset_enemies():
	for i in range(0, enemies.get_child_count()):
		var enemy = enemies.get_child(i)
		enemy.queue_free()
	var enemies = preload("res://objects/scene's/maps/testArea_enemies.tscn").instance()
	$enemies.add_child(enemies);
	pass