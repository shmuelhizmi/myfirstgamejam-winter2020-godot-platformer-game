extends state

func physics_process(delta):
	if owner.is_on_floor():
		state_machine.transition_to("idle")

func _enter():
	pass

func _exit():
	pass