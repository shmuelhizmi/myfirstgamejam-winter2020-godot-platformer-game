extends KinematicBody2D

export var jump_hight : int = -600

func _on_toch_to_jump_body_entered(body):
	
	if body.name == 'player_body' and Input.is_action_pressed('player_jump'):
		body.get_parent().velocity.y = jump_hight - 100
	
	elif body.name == 'player_body':
		body.get_parent().velocity.y = jump_hight
	
	
