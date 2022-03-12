extends Node2D

onready var Offset = self.transform.origin - get_parent().get_node("Player").transform.origin;

# warning-ignore:unused_argument
func _process(delta):
	self.transform.origin = (get_parent().get_node("Player").transform.origin + Offset) + Vector2(-70, 150);
	var energium = get_parent().get_node("Player").energium;
	$Label.set_text(str("EnerG: ", energium, " g"));
