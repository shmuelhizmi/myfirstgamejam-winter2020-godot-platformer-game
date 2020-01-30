extends Label

var once = false

func _ready():
	self.modulate = Color(1, 1, 1, 0)

func _on_touch_body_entered(body):
	if once == false:
		if body.name == 'player_body':
			$AnimationPlayer.play("show")
			once = true
