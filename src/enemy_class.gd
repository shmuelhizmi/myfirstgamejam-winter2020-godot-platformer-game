extends KinematicBody2D
class_name enemy
onready var initial_state = self  
 
export(int) var slideness = 100;
#warning-ignore:unused_class_variable
export(int) var speed = 180;

#warning-ignore:unused_class_variable
var velocity:Vector2 = Vector2()
#warning-ignore:unused_class_variable
var up:Vector2 = Vector2(0, -1)
#warning-ignore:unused_class_variable
var gravityScale = 1200
#warning-ignore:unused_class_variable
onready var raycast1: RayCast2D = $rayCast1
#warning-ignore:unused_class_variable
onready var raycast2: RayCast2D = $rayCast2

func _ready():
	add_to_group("enemy")

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

func reset():
	print("RESET")
	self = initial_state