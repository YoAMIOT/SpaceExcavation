extends Node2D

onready var Offset = self.transform.origin - get_parent().get_node("Player").transform.origin;

# warning-ignore:unused_argument
func _process(delta):
	self.transform.origin = (get_parent().get_node("Player").transform.origin + Offset) + Vector2(-70, 110);
	var ressources = get_parent().get_node("Player").ressources;
	$Label.set_text(str("Rsrcs: ", ressources , " kg"));
