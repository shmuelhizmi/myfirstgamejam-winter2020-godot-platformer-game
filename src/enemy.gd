extends KinematicBody2D

export(int) var slideness = 0.2
export(int) var speed = 280;

var velocity:Vector2 = Vector2()
var up:Vector2 = Vector2(0, -1)
var gravityScale = 1200
enum Direction {L=-1, R=1}

var currentDirection:int = Direction.L
onready var raycast1: RayCast2D = $rayCast1
onready var raycast2: RayCast2D = $rayCast2

func _physics_process(delta):
	velocity.y += gravityScale * delta
	velocity.x = currentDirection * speed
	velocity += slide()
	
	# If left hand is a hole, then go right
	if !raycast1.is_colliding():
		currentDirection = Direction.R
		pass
	# If right hand is a hole, then go left
	if !raycast2.is_colliding():
		currentDirection = Direction.L
		pass
	velocity = move_and_slide(velocity, up)

# Slide algorithm, basically the same with player.gd
# Consider making a component to make all things slide the same way (obstacles, enemies, player)?
func slide():
	var ground1 = raycast1.get_collider()
	var ground2 = raycast2.get_collider()
	var rotationDegrees = 0.0
	var divideBy = 0
	if ground1 != null and not "player" in ground1.name :
		rotationDegrees += ground1.rotation_degrees
		divideBy+=1;
		pass
	if ground1 != null and not "player" in ground1.name :
		rotationDegrees += ground1.rotation_degrees
		divideBy+=1
		pass
	if rotationDegrees==0 :
		return Vector2()
	rotationDegrees = rotationDegrees / divideBy
	rotation_degrees = rotationDegrees
	return (Vector2(1,1)* ( rad2deg(rotationDegrees)* slideness ))
