extends Node2D

onready var enemies = $enemies

func _ready():
	get_tree().paused = false

func reset_enemies():
	$enemies.call("_reset");
	pass