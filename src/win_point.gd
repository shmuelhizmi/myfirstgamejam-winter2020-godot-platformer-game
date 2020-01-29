extends Area2D

export var scene : String


func _on_win_point_body_entered(body):
	if body.name == "player_body":
		get_tree().paused = true
		#$win_music.play()
		$CanvasLayer/AnimationPlayer.play("fade_out")


#func _on_win_music_finished():
#	$AnimationPlayer.play("fade_out")


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene(scene)
