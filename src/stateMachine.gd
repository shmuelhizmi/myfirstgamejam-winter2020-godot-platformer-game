extends Node
class_name stateMachine

onready var current_state: state = get_child(0)

func _ready():
	current_state._enter()

func transition_to(to_state: NodePath):
	set_physics_process(false)
	current_state._exit()
	current_state = get_node(to_state)
	print(current_state.name)
	current_state._enter()
	set_physics_process(true)

func _physics_process(delta):
	current_state.physics_process(delta)
	