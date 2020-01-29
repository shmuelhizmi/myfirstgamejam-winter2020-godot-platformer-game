extends Area2D

var motion : Vector2 = Vector2()
var speed : int = 400
var dir : int = 1

func _physics_process(delta):
	motion.x = speed * dir * delta
	translate(motion)

func dir(way):
	dir = way

func _on_range_attack_body_entered(body):
	if body.name != "player_body":
		queue_free()

func _on_bye_timeout():
	queue_free()
