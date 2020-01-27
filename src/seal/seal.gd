extends enemy
export(int) var jump_force = 300;

func _physics_process(delta):
	velocity.y += gravityScale * delta
	velocity += slide()
		
	velocity = move_and_slide(velocity, up)
