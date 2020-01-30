extends Control

onready var player = get_parent().get_parent().get_parent().get_parent()
onready var h1 = get_node("1")
onready var h2 = get_node("2")
onready var h3 = get_node("3")

var empty = preload("res://assets/sprites/Empty Heart.png")


func _physics_process(delta):
	
	if player.lifes == 3:
		return
	
	elif player.lifes == 2:
		h3.texture = empty
	
	elif player.lifes == 1:
		h3.texture = empty
		h2.texture = empty
	
	elif player.lifes == 0:
		h3.texture = empty
		h2.texture = empty
		h1.texture = empty
