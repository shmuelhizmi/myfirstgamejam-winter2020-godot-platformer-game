extends Node2D
export var enemiesScene:PackedScene;
onready var enemies = $enemies

func _ready():
	get_tree().paused = false

func reset_enemies():
	for i in range(0, enemies.get_child_count()):
		var enemy = enemies.get_child(i)
		enemy.queue_free()
		yield(get_tree().create_timer(0.1), "timeout");
	var enemies = enemiesScene.instance()
	$enemies.add_child(enemies);
	pass