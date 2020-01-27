extends enemy

enum Direction {L=-1, R=1}
var currentDirection:int = Direction.L

# raycast 3,4 are for detecting sides collision (Left, Right)
onready var raycast3: RayCast2D = $rayCast3
onready var raycast4: RayCast2D = $rayCast4

func _physics_process(delta):
	velocity.y += gravityScale * delta
	velocity.x = currentDirection * speed
	velocity += slide()
	
	# If left hand is a gap or wall, then go right
	if !raycast1.is_colliding():
		currentDirection = Direction.R
	if raycast3.is_colliding() and raycast3.get_collider().name != "player_body":
		currentDirection = Direction.R
	
	# If right hand is a gap or wall, then go left
	if !raycast2.is_colliding():
		currentDirection = Direction.L
	if raycast4.is_colliding() and raycast4.get_collider().name != "player_body":
		currentDirection = Direction.L

	velocity = move_and_slide(velocity, up)