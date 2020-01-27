extends state
onready var timer = $timer

func _ready():
	timer.connect("timeout", state_machine, "transition_to", ["seek"]) 

func physics_process(delta):
	owner.velocity.x /= 1.1

func _enter():
	timer.start()

func _exit():
	pass