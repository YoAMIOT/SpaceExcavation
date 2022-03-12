extends RigidBody2D

func _on_hitbox_area_entered(area):
	if area.is_in_group("Edges"):
		gravity_scale = 9;



func _on_hitbox_area_exited(area):
	if area.is_in_group("Edges"):
		gravity_scale = -9;
