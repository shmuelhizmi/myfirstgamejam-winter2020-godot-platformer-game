extends Button
var tutorial;
func _ready():
	tutorial = get_node("../../tutorial");
	pass
func _pressed():
	if tutorial.visible:
		tutorial.visible = false;
		pass
	else:
		tutorial.visible = true;
		pass
	pass