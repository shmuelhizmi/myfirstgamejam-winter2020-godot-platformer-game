extends state
onready var collisionDetector: Area2D = $"../../collisionDetector"

func _enter():
	collisionDetector.set_deferred("monitoring", true)

func _exit():
	collisionDetector.set_deferred("monitoring", false)

func jump_to(to):
	owner.velocity += ((to - owner.global_position).normalized() + Vector2(0, -1)) * owner.jump_force

func _on_collisionDetector_body_entered(body):
	if body.name == "player_body":
		jump_to(body.global_position)
		state_machine.transition_to("jump")
