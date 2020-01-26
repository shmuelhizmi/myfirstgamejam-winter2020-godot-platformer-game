extends KinematicBody2D

export(int) var slideness = 100
export(int) var jump_force = 300;


var velocity:Vector2 = Vector2()
var up:Vector2 = Vector2(0, -1)
var gravityScale = 1200
enum Direction {L=-1, R=1}

var currentDirection:int = Direction.L
onready var raycast1: RayCast2D = $rayCast1
onready var raycast2: RayCast2D = $rayCast2

func _physics_process(delta):
	velocity.y += gravityScale * delta
	velocity += slide()
		
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

# Jump to the global position of "to"
func jump_to(to):
	velocity += ((to - global_position).normalized() + Vector2(0, -1)) * jump_force

func _on_collisionDetector_body_entered(body):
	print(body.name)
	if body.name == "player_body":
		jump_to(body.global_position)
