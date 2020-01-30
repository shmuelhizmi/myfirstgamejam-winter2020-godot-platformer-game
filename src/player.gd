extends Node

#player nodes
onready var body : KinematicBody2D = get_node("player_body");
onready var sprite : Sprite= get_node("player_body/sprite");
onready var camera : Camera2D = get_node("camera");
onready var audioStreamPlayer : AudioStreamPlayer2D = get_node("camera/audioStreamPlayer");
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
var die : bool = false
export var lifes = 3;
export var maximum_lifes = 3;
var lastCheckpoint;
# movement properties
export var speed = 280;
#warning-ignore:unused_class_variable
export var runningMultiplier = 1.3;
export var jumpForce = 500;
export var gravityScale = 20;
export var slideness = 450;
export var slidenessAccumulation = 0.3;

#attack:
var can_attack : bool = true
var attacking : bool = false


#player animations
export var idleAnimationName="";
export var walkAnimationName="";
export var slideAnimationName="";
export var runAnimationName="";
export var jumpAnimationName="";
export var crouchAnimationName="";

#preloads:
var range_attack = preload("res://objects/scene\'s/spell and attacks/range_attack.tscn")

#audio
#warning-ignore:unused_class_variable
onready var diveAudioStream = preload("res://assets/audio/Penguin_action/Penguin_dive.wav")
onready var walkAudioStream = preload("res://assets/audio/Penguin_action/Penguin_walk.wav")
onready var jumpAudioStream = preload("res://assets/audio/Penguin_action/Penguin_jump.wav")
#warning-ignore:unused_class_variable
onready var hitAudioStream = preload("res://assets/audio/Penguin_action/Penguin_hit.wav")
onready var pick_sound = preload("res://assets/audio/Penguin_action/collect_item.wav")
onready var dead = preload("res://assets/audio/Penguin_action/Penguin_die.wav")

var velocity = Vector2();
var up = Vector2(0, -1);
#warning-ignore:unused_class_variable
var currentAction = "idle";

var ice = false;

enum Direction {L=-1, R=1}

#warning-ignore:unused_argument

func _ready():
	drawLifes();
	lastCheckpoint = body.position;
	pass


func _process(delta):
	velocity.x=0;
	handleInput()
	updateAnimation();
	velocity.y += gravityScale;
	velocity = body.move_and_slide(velocity, up);
	update_camera(delta);
	pass

func updateAnimation():
	if animationPlayer.current_animation=="power":
		return
	if Input.is_action_pressed("player_right") or Input.is_action_pressed("player_left"):
		if body.is_on_floor():
			if animationPlayer.current_animation!="run":
				animationPlayer.current_animation="run";
				play_sound(walkAudioStream)
		else:
			if animationPlayer.current_animation!="run_air":
				animationPlayer.current_animation="run_air";
		if velocity.x>0:
			sprite.flip_h = false; 
		else:
			sprite.flip_h =true;
	else:
		if animationPlayer.current_animation!="idle":
			audioStreamPlayer.get_node("walkSoundTimer").stop()
			animationPlayer.current_animation="idle"
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
	var attackdown = Input.is_action_pressed('player_attack');
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
			if sign($player_body/Position2D.position.x) == -1:
				$player_body/Position2D.position.x = $player_body/Position2D.position.x * -1
			actionMove(Direction.R);
			pass
		if leftDown:
			if sign($player_body/Position2D.position.x) == 1:
				$player_body/Position2D.position.x = $player_body/Position2D.position.x * -1
			actionMove(Direction.L);
			pass
		pass
		
		if attackdown:
			if can_attack == true:
				can_attack = false
				$attack.start()
				var attack_p = range_attack.instance()
				get_parent().add_child(attack_p)
				attack_p.global_position = $player_body/Position2D.global_position
				if sign($player_body/Position2D.position.x) == 1:
					attack_p.dir(1)
				elif sign($player_body/Position2D.position.x) == -1:
					attack_p.dir(-1)
				#attacking = true
				
			
		
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
	play_sound(jumpAudioStream)
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
		play_sound(pick_sound)
		area.queue_free();
		pass


func onCollideCollectable(collectable):
	animationPlayer.play("power");
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
		get_tree().paused = true
		play_sound(dead)
		return true;
	else:
		get_parent().call("reset_enemies");
		body.position = lastCheckpoint;
		return true;
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

func play_sound(sound):
	audioStreamPlayer.stream = sound
	audioStreamPlayer.play()
	if sound == dead:
		die = true
	
	if sound == walkAudioStream:
		audioStreamPlayer.get_node("walkSoundTimer").start()
	else:
		audioStreamPlayer.get_node("walkSoundTimer").stop()

func _on_walkSoundTimer_timeout():
	audioStreamPlayer.play()


func _on_audioStreamPlayer_finished():
	if die == true:
		get_tree().reload_current_scene();


func _on_attack_timeout():
	can_attack = true
