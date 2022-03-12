extends Node2D

onready var Offset = self.transform.origin - get_parent().get_node("Player").transform.origin;

func _process(_delta):
	self.transform.origin = (get_parent().get_node("Player").transform.origin + Offset) + Vector2(-100, 100);
