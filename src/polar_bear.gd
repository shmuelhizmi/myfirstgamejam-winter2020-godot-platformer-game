extends KinematicBody2D


#vars_AI:
var right : bool = false
var left : bool = false 
var target = null
var attack : bool = false
var stop_det : bool = false

#vars_phy:
var motion : Vector2 = Vector2()
var gravity : int = 10
var acc : int = 5
var max_speed : int = 300


#warning-ignore:unused_argument
func _physics_process(delta):
	
	motion.y += gravity
	motion = move_and_slide(motion)
	
	if right == true:
		left = false
		$Sprite.flip_h = false
		motion.x += acc
		if motion.x >= max_speed:
			motion.x = max_speed
	
	elif left == true:
		right = false
		$Sprite.flip_h = true
		motion.x -= acc
		if motion.x <= -max_speed:
			motion.x = -max_speed
	
	
	
	if attack == true:
		print(target.position.x)
		if is_instance_valid(target) == true:
			if self.position.x > target.position.x - 100:
				right = false
				left = true
		
			elif self.position.x < target.position.x + 100:
				left = false
				right = true
			
	else:
		right = false
		left = false
		motion.x = lerp(motion.x, 0, 1)
		stop_det = false


func _on_touch_to_die_body_entered(body):
	if body.name == "player_body":
		body.get_parent().damage()
		$detact/CollisionShape2D.disabled = true
		$wait.start()
		attack = false
		stop_det = false


func _on_detact_body_entered(body):
	if stop_det == false:
		if body.name == "player_body":
			target = body
			attack = true
			stop_det = true


func _on_wait_timeout():
	$detact/CollisionShape2D.disabled = false
