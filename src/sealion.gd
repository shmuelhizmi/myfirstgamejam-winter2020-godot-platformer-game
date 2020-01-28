extends KinematicBody2D

export(int) var slideness = 100;
export(int) var speed = 180;
export (Texture)var vulnerableSprite;
var velocity:Vector2 = Vector2()
var up:Vector2 = Vector2(0, -1)
var gravityScale = 1200
enum Direction {L=-1, R=1}
enum state {walk=1, vulnerable=-1}

var currentState:int = state.walk;
var currentDirection:int = Direction.L
# raycast 1,2 are for detecting gap (Left, Right)
onready var raycast1: RayCast2D = $rayCast1
onready var raycast2: RayCast2D = $rayCast2
# raycast 3,4 are for detecting sides collision (Left, Right)
onready var raycast3: RayCast2D = $rayCast3
onready var raycast4: RayCast2D = $rayCast4

var gotPushed =false
func _physics_process(delta):
	velocity.y += gravityScale * delta
	velocity.x = 0;
	
	if currentState == state.walk or gotPushed:
		if !raycast2.is_colliding():
			currentDirection = Direction.L;
			pass
		if raycast4.is_colliding() and raycast4.get_collider().name != "player_body":
			currentDirection = Direction.L;
			pass
		pass
		if currentState == state.walk:
			velocity.x = currentDirection * speed
			velocity += slide()
			if !raycast1.is_colliding():
				currentDirection = Direction.R;
				pass
			if raycast3.is_colliding() and raycast3.get_collider().name != "player_body":
				currentDirection = Direction.R;
				pass
		else:
			if gotPushed:
				velocity.x += currentDirection* speed  *3;
				$sprite.rotate(0.3);
				pass

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
		return normal*slideness*Vector2(1,-0.2);
	return Vector2();

func _on_vulnerableArea_body_entered(body: PhysicsBody2D):
	if body!=null and "player" in body.name.to_lower():
		if currentState == state.walk:
			body.get_parent().call("actionJump")
			currentState = state.vulnerable;
			scale= Vector2(0.5,0.5);
			$sprite.texture = vulnerableSprite;
		else:
			if not gotPushed:
				push(body);
			else:
				body.get_parent().call("damage")
				pass

func _on_vulnerableArea_area_entered(area):
	if "DeadZone" in area.name:
		queue_free();
	if "CollisionDetector" in area.name:
		if "player" in area.get_parent().name:
			if not gotPushed:
				push(area.get_parent())
			else:
				area.get_parent().get_parent().call("damage")
				pass
		pass

func push(player):
	if currentState == state.vulnerable :
		gotPushed=true;
		if player.position.x>position.x:
			currentDirection=Direction.L;
		else:
			currentDirection=Direction.R;
	pass

func _on_unvulnerableArea2_body_entered(body: PhysicsBody2D):
	if body!=null and "player" in body.name.to_lower():
		if currentState == state.walk:
			body.get_parent().call("damage")
			pass
		else:
			gotPushed = true;
	pass 
