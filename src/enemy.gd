extends KinematicBody2D

export(int) var slideness = 10
export(int) var speed = 2;

var velocity:Vector2 = Vector2()
var up:Vector2 = Vector2(0, -1)
var gravityScale = 1200
enum Direction {L=-1, R=1}

var currentDirection:int = Direction.L
onready var rayCast1: RayCast2D = $rayCast1
onready var rayCast2: RayCast2D = $rayCast2

func _physics_process(delta):
	velocity.x = speed * currentDirection
	velocity.y += gravityScale
	velocity += slide();
	if !rayCast1.is_colliding() or !rayCast2.is_colliding():
		currentDirection *= -1
	velocity = move_and_slide(velocity, up)

func slide():
	var ground1:Node2D  = rayCast1.get_collider()
	var ground2:Node2D  = rayCast1.get_collider()
	var rotationDegrees = 0
	var divideBy = 0
	if ground1 != null or ground2 != null:
		if ground1 != null:
			rotationDegrees += ground1.rotation_degrees
			divideBy += 1
		if ground2 != null:
			rotationDegrees += ground2.rotation_degrees
			divideBy += 1
	else:
		return Vector2(0, 0)
	rotationDegrees = rotationDegrees / divideBy
	rotation_degrees = rotationDegrees
	return Vector2(1, 1) * (rad2deg(rotationDegrees) * slideness)