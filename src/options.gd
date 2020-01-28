extends Control


func _ready():
	$AnimationPlayer/fade.visible = true
	$AnimationPlayer/fade.modulate = Color(0, 0, 0, 1)
	$AnimationPlayer.play("fade_in_options")


func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('music'), value)
	$music/music_volume.play()

func _on_sounds_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('sounds'), value)
	$sounds/music_volume.play()


func _physics_process(delta):
	if $music.value == 0:
		$music/value.text =  '100%'
	elif $music.value == -10:
		$music/value.text =  '80%'
	elif $music.value == -20:
		$music/value.text =  '60%'
	elif $music.value == -30:
		$music/value.text =  '40%'
	elif $music.value == -40:
		$music/value.text =  '20%'
	elif $music.value == -50:
		$music/value.text =  '0%'

	if $sounds.value == 0:
		$sounds/value.text =  '100%'
	elif $sounds.value == -10:
		$sounds/value.text =  '80%'
	elif $sounds.value == -20:
		$sounds/value.text =  '60%'
	elif $sounds.value == -30:
		$sounds/value.text =  '40%'
	elif $sounds.value == -40:
		$sounds/value.text =  '20%'
	elif $sounds.value == -50:
		$sounds/value.text =  '0%'




func _on_back_pressed():
	$AnimationPlayer.play('fade_out')


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'fade_out':
		get_tree().change_scene("res://objects/scene\'s/ui/start_screen.tscn")