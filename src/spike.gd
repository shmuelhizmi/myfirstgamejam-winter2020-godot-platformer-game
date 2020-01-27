extends KinematicBody2D

func _on_toch_to_die_body_entered(body):
	if body.name == "player_body":
		body.get_parent().damage()
