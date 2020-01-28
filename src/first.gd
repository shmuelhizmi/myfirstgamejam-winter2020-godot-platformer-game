extends Node

var what_to_say : Array = ['WHERE AM I?', 'MY HEAD HURTS SO BAD', 'I CANT REMEMBER ANYTHING']
var page = 0

func _ready():
	$Label.visible_characters = 0
	$Label.text = what_to_say[page]
	$spawn_letters.start()

func _on_spawn_letters_timeout():
	if $Label.visible_characters < $Label.get_total_character_count():
		$Label.visible_characters = $Label.visible_characters + 1
	
	else:
		$spawn_letters.stop()
		$wait.start()


func _on_wait_timeout():
	page = page + 1
	if page != 3:
		$Label.visible_characters = 0
		$Label.text = what_to_say[page]
		$spawn_letters.start()
	
	elif page == 3:
		$Label.visible_characters = 0
		$go.start()


func _on_go_timeout():
#warning-ignore:return_value_discarded
	get_tree().change_scene("res://objects/scene\'s/maps/testArea.tscn")
