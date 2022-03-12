extends Node2D

var spawned = 0;

###FONCTION DE DETECTION DE FIN DE GENERATION DE NIVEAU###
func _on_PlanetSpawner_doneCreatingLevel():
	spawned += 1;
	spawner();



###FONCTION DE GENERATION PROCEDURALE D'ASTEROIDES###
func spawner():
	if spawned == 1:
		var rdm = RandomNumberGenerator.new();
		var asteroidScene = load("res://scenes/Asteroid.tscn");

# warning-ignore:unused_variable
		for i in range(50):
			var asteroid = asteroidScene.instance();
			rdm.randomize();
			var xPos = rdm.randf_range(-7150, 7150);
			rdm.randomize();
			var yPos = rdm.randf_range(-7150, 7150);
			rdm.randomize()
			var rot = rdm.randf_range(0, 359);
			rdm.randomize()
			var xScale = rdm.randf_range(0.5, 1.5);
			rdm.randomize()
			var yScale = rdm.randf_range(0.5, 1.5);
			rdm.randomize();
			var xVelocity = rdm.randf_range(100, 200);

			asteroid.position.x = xPos;
			asteroid.position.y = yPos;
			asteroid.rotation_degrees = rot;
			asteroid.get_node("Sprite").scale.x = xScale;
			asteroid.get_node("Sprite").scale.y = yScale;
			asteroid.get_node("Collision").scale.x = xScale;
			asteroid.get_node("Collision").scale.y = yScale;
			asteroid.get_node("hitbox/hitbox").scale.x = xScale;
			asteroid.get_node("hitbox/hitbox").scale.y = yScale;
			asteroid.linear_velocity.x = xVelocity;
			add_child(asteroid);
