extends Node

#player nodes
onready var body : KinematicBody2D = get_node("player_body");
onready var sprite : Sprite= get_node("player_body/sprite");
onready var camera : Camera2D = get_node("camera");
onready var audioStreamPlayer : AudioStreamPlayer2D = get_node("audioStreamPlayer");
onready var animationPlayer : AnimationPlayer = sprite.get_node("animationPlayer");

#ui
onready var lifelable : Label = get_node("hud/container/Top/life");
onready var abilities = {
	run=get_node("hud/container/Top/abilities/run"),
	ice=get_node("hud/container/Top/abilities/ice"),
	bunny=get_node("hud/container/Top/abilities/bunny")
	};

	#player properties
#logic properties
export var lifes = 3;
export var maximum_lifes = 3;
var lastCheckpoint;
# movement properties
export var speed = 280;
export var runningMultiplier = 1.3;
export var jumpForce = 500;
export var gravityScale = 20;
export var slideness = 450;
export var slidenessAccumulation = 0.3;


#player animations
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

var ice = false;

enum Direction {L=-1, R=1}


func _ready():
	drawLifes();
	lastCheckpoint = body.position;
	pass


func _process(delta):
	handleInput()
	velocity.y += gravityScale;
	velocity = body.move_and_slide(velocity, up);
	update_camera(delta);
	pass

var slideForce = 0;
func slide():
	if body.get_slide_count() > 0 and body.is_on_floor():
		var collision = body.get_slide_collision(0);
		var normal = collision.get_normal()
		var angleDelta = normal.angle() - (body.rotation - (PI*0.5))
		if abs(angleDelta + body.rotation)<0.8:
			body.rotation += angleDelta;
		else:
			body.rotation = 0;
		var resualt = normal*slideness*Vector2(1,-0.5);
		slideForce+=resualt.x*slidenessAccumulation;
		return resualt;
	return Vector2();


func handleInput():
	var slideDown = Input.is_action_pressed("player_slide");
	var jumpDown = Input.is_action_pressed("player_jump");
	var rightDown = Input.is_action_pressed("player_right");
	var leftDown = Input.is_action_pressed("player_left");
	var slidenessAccumulationStep = slideForce*(slidenessAccumulation);
	slideForce+= -slidenessAccumulationStep/5;
	velocity.x = 0;
	if not slideDown or (rightDown or leftDown):
		body.rotation = 0;
		velocity.x+=slidenessAccumulationStep;
		if jumpDown:
			if body.is_on_floor():
				actionJump();
				pass
			pass
		if rightDown:
			actionMove(Direction.R);
			pass
		if leftDown:
			actionMove(Direction.L);
			pass
		pass
		if ice:
			velocity += slide()*0.3;
			pass
	else:
		velocity += slide();


func update_camera(delta):
	if body.position.x > camera.position.x-100:
		camera.position+=Vector2(delta*(abs(body.position.x-camera.position.x+200)),0)
	elif body.position.x < camera.position.x:
		camera.position+=-Vector2(delta*(abs(body.position.x-camera.position.x)),0)
		pass

func actionJump(extraVelocity=0):
	velocity.y = -jumpForce-extraVelocity;
	pass

func actionMove(directin):
	velocity.x += (speed * directin);
	pass


func _on_CollisionDetector_body_entered(collider):
	if collider.is_in_group("enemy"):
		damage();
		pass
	if "DeadZone" in collider.name:
		damage()


func _on_CollisionDetector_area_entered(area):
	if "DeadZone" in area.name:
		damage()
	if "checkpoint" in area.name:
		lastCheckpoint = area.position;
		area.queue_free();
		pass
	if "collectable" in area.name:
		onCollideCollectable(area.name);
		area.queue_free();
		pass


func onCollideCollectable(collectable):
	if "speed" in collectable:
		startCollectable(getCollectableTime(collectable),"start_ability_speed","end_ability_speed");
	pass
	if "ice" in collectable:
		startCollectable(getCollectableTime(collectable),"start_ability_ice","end_ability_ice");
	pass
	if "bunny" in collectable:
		startCollectable(getCollectableTime(collectable),"start_ability_bunny","end_ability_bunny");
	pass


func startCollectable(time,startFunction,endFunction):
	var timer = Timer.new();
	timer.one_shot = true;
	timer.connect("timeout",self,endFunction)
	call(startFunction);
	add_child(timer);
	timer.start(time);
	pass


func getCollectableTime(collectable):
	var timeropen = "_time_";
	var timerclose = "_time;";
	var timestr = collectable.substr(collectable.find(timeropen),collectable.find_last(timerclose));
	timestr=timestr.replace(timeropen,"");
	timestr=timestr.replace(timerclose,"");
	if timestr != null:
		return int(timestr);
	return 30;


func damage():
	lifes=lifes-1;
	drawLifes();
	if lifes<=0:
		get_tree().reload_current_scene();
		pass
	else:
		body.position = lastCheckpoint;
		get_parent().call("reset_enemies");
		pass	
	pass


func drawLifes():
	var lifecount = 0;
	lifelable.text="";
	while lifecount < maximum_lifes:
		lifecount+=1;
		if lifecount>lifes:
			lifelable.text+="x";
			pass
		else:
			lifelable.text+="♥ ";
			pass
		pass
		
	pass


#abilities
func start_ability_speed():
	abilities.run.visible = true;
	speed+=90;
	pass


func end_ability_speed():
	abilities.run.visible = false;
	speed+=-90;
	pass


func start_ability_ice():
	abilities.ice.visible = true;
	ice= true;
	slideness+=190;
	pass


func end_ability_ice():
	abilities.ice.visible = false;
	ice  = false;
	slideness+=-190;
	pass

func start_ability_bunny():
	abilities.bunny.visible = true;
	jumpForce+=230;
	pass

func end_ability_bunny():
	abilities.bunny.visible = false;
	jumpForce+=-230;
	pass

