extends Node

var can_click : bool = false
var go_to : String = ''

func _ready():
	print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index('music')))
	print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index('sounds')))
	$AnimationPlayer/fade.visible = true
	$AnimationPlayer/fade.modulate = Color(0, 0, 0, 1)
	$AnimationPlayer.play("fade_in")
	$buttons/exit.modulate = Color(1, 1, 1, 0)
	$buttons/start.modulate = Color(1, 1, 1, 0)
	$buttons/options.modulate = Color(1, 1, 1, 0)
	$buttons.position.x = 87.064




func _on_start_pressed():
	if can_click == true:
		can_click = false
		go_to = 'start'
		$AnimationPlayer.play("fade_out")

func _on_options_pressed():
	if can_click == true:
		can_click = false
		go_to = 'options'
		$AnimationPlayer.play("fade_out")

func _on_exit_pressed():
	if can_click == true:
		can_click = false
		go_to = 'exit'
		$AnimationPlayer.play("fade_out")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'fade_out':
		if go_to == 'start':
#warning-ignore:return_value_discarded
			get_tree().change_scene("res://objects/scene\'s/maps/testArea.tscn")
		
		elif go_to == 'options':
#warning-ignore:return_value_discarded
			get_tree().change_scene("res://objects/scene\'s/ui/options.tscn")
		
		elif go_to == 'exit':
			get_tree().quit()
	
	elif anim_name == 'fade_in':
		can_click = true

#buttons_anim:
func _on_start_mouse_entered():
	$buttons/start/name.modulate = Color(1, 1, 1, 0.6)

func _on_start_mouse_exited():
	$buttons/start/name.modulate = Color(1, 1, 1, 1)

func _on_options_mouse_entered():
	$buttons/options/name.modulate = Color(1, 1, 1, 0.6)

func _on_options_mouse_exited():
	$buttons/options/name.modulate = Color(1, 1, 1, 1)

func _on_exit_mouse_entered():
	$buttons/exit/name.modulate = Color(1, 1, 1, 0.6)

func _on_exit_mouse_exited():
	$buttons/exit/name.modulate = Color(1, 1, 1, 1)
