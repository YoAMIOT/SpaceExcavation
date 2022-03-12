extends Area2D

func _on_EdgesKiller_body_entered(body):
	if body.is_in_group("Asteroid"):
		body.queue_free();
