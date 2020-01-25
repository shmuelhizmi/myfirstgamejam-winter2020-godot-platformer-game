
extends Node

var body;
var raycast1;
var raycast2;
var audioStreamPlayer;
var animationPlayer;

#ui
var lifelable;

export var lifes = 3;

export var speed = 280;
export var runningMultiplier = 1.3;
export var jumpForce = 450;
export var gravityScale = 1200;
export var slideness = 10;

export var idleAnimationName="";
export var walkAnimationName="";
export var slideAnimationName="";
export var runAnimationName="";
export var jumpAnimationName="";
export var crouchAnimationName="";

var jumpAudioStream;
var slideAudioStream;
var walkAudioStream;

var velocity = Vector2();
var up = Vector2(0, -1);
var currentAction = "idle";

# Called when the node enters the scene tree for the first time.
func _ready():
	body = get_node("body");
	raycast1 = body.get_node("rayCast1");
	raycast2 = body.get_node("rayCast2");
	audioStreamPlayer = get_node("audioStreamPlayer");
	animationPlayer = get_node("body/sprite/animationPlayer");
	
	lifelable = get_node("hud/container/Top/life");
	lifelable.text = str(lifes);
	
	jumpAudioStream = load("res://assets/CS_FMArp B_110-C.ogg");
	slideAudioStream = load("res://assets/CS_FMArp B_110-C.ogg");
	walkAudioStream = load("res://assets/CS_FMArp B_110-C.ogg");
	
	
	pass # Replace with function body.

func _process(delta):
	handleInput()
	velocity.y += gravityScale * delta;
	velocity+= slide()* delta;
	velocity = body.move_and_slide(velocity, up);
	var collision = body.move_and_collide(Vector2());
	if collision!= null:
		onCollide(collision);
		pass
	pass

func slide():
	var ground1 = raycast1.get_collider();
	var ground2 = raycast2.get_collider();
	var rotationDegrees = 0.0;
	var divideBy = 0;
	if ground1!=null :
		rotationDegrees += ground1.rotation_degrees;
		divideBy+=1;
		pass
	if ground1!=null :
		rotationDegrees += ground1.rotation_degrees;
		divideBy+=1;
		pass
	if rotationDegrees==0 :
		body.rotation_degrees = 0;
		return Vector2()

	rotationDegrees = rotationDegrees / divideBy;
	body.rotation_degrees = rotationDegrees;
	return Vector2(1,0.5)* ( rad2deg(rotationDegrees)* slideness )

func handleInput():
	velocity.x = 0;
	if Input.is_action_pressed("player_jump"):
		if body.is_on_floor():
			velocity.y = -jumpForce;
			pass
		pass
	if Input.is_action_pressed("player_right"):
		actionMove(1,Input.is_action_pressed("player_run"));
		pass
	if Input.is_action_pressed("player_left"):
		actionMove(-1,Input.is_action_pressed("player_run"));
		pass
	pass
	
func actionMove(directin, isRunning):
	if isRunning :
		velocity.x += speed * directin * runningMultiplier;
		pass
	else:
		velocity.x += speed * directin;
	pass
	
func onCollide(collider):
	if "enemy" in collider.collider.name:
		lifes=lifes-1;
		lifesChanged()
		pass;
	pass
	
func lifesChanged():
	lifelable.text=str(lifes);
	pass