extends "res://src/spike.gd"
onready var playerDetector: RayCast2D = $playerDetector
export(int) var fallingSpeed = 200
var detected = false

func _process(delta):
	if detected == true:
		move_and_slide(Vector2(0, fallingSpeed), Vector2(0,-1))

func _on_playerDetector_body_entered(body):
	if body.name == "player_body":
		detected = true
