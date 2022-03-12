extends Node2D

signal creatingLevel;
signal doneCreatingLevel;

func _on_PlanetSpawner_creatingLevel():
	emit_signal("creatingLevel");


func _on_PlanetSpawner_doneCreatingLevel():
	var rdm = RandomNumberGenerator.new();
	rdm.randomize();
	var rdmPlanet = rdm.randf_range(1, 5);
	rdm.randomize();
	var rdmSpawn = rdm.randf_range(9, 10);
	
	var planet = get_node("/root/Node2D/PlanetSpawner").get_child(rdmPlanet);
	
	var spawnPoint = planet.get_child(rdmSpawn);
	
	$Station.rotation_degrees = spawnPoint.rotation_degrees;
	$Station.global_position = spawnPoint.global_position;
	get_node("Station/unloadPos").rotation_degrees = spawnPoint.rotation_degrees;
	$Player.global_position = get_node("Station/unloadPos").global_position;
	$Player.rotation_degrees = get_node("Station/unloadPos").rotation_degrees;
	$Player/LoadingScreen.rotation_degrees -= spawnPoint.rotation_degrees;
	
	emit_signal("doneCreatingLevel");
