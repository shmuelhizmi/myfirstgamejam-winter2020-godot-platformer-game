extends KinematicBody2D

export(int) var slideness = 100;
export(int) var speed = 180;

var velocity:Vector2 = Vector2()
var up:Vector2 = Vector2(0, -1)
var gravityScale = 1200
enum Direction {L=-1, R=1}

var currentDirection:int = Direction.L
# raycast 1,2 are for detecting gap (Left, Right)
onready var raycast1: RayCast2D = $rayCast1
onready var raycast2: RayCast2D = $rayCast2
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

# Slide algorithm, basically the same with player.gd
# Consider making a component to make all things slide the same way (obstacles, enemies, player)?
func slide():
	if get_slide_count() > 0 and is_on_floor():
		var collision = get_slide_collision(0);
		var normal = collision.get_normal()
		var angleDelta = normal.angle() - (rotation - (PI*0.5))
		if abs(angleDelta + rotation)<0.8:
			rotation += angleDelta;
		else:
			rotation = 0;
		return normal*slideness*Vector2(1,0);
	return Vector2();
