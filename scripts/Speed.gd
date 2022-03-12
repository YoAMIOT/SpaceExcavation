extends Node2D

onready var Offset = self.transform.origin - get_parent().get_node("Player").transform.origin;

# warning-ignore:unused_argument
func _process(delta):
	self.transform.origin = (get_parent().get_node("Player").transform.origin + Offset) + Vector2(-30, 40);
	var speed = get_parent().get_node("Player").speed;
	$Label.set_text(str(speed , " m/s"));
