extends Node2D

var creatingLevel = false;
var firstCheck = false;

signal creatingLevel;
signal doneCreatingLevel;

###FONCTION DE PROCESS###
# warning-ignore:unused_argument
func _process(delta):
	spawner();



###FONCTION DE GENERATION PROCEDURALE DE PLANETE###
func spawner():
	var rdm = RandomNumberGenerator.new();
	var planetScene = load("res://scenes/Planet.tscn");
	
	if (get_child_count() != 6):
		creatingLevel = true;
		emit_signal("creatingLevel");
		
		var planet = planetScene.instance();
		rdm.randomize();
		var xPos = rdm.randf_range(-4850, 4850);
		rdm.randomize();
		var yPos = rdm.randf_range(-4850, 4850);
		rdm.randomize();
		var planetScale = rdm.randf_range(5, 9);
		rdm.randomize();
		var rot = rdm.randf_range(0, 359);

		planet.position.x = xPos;
		planet.position.y = yPos;
		planet.scale.x = planetScale;
		planet.scale.y = planetScale;
		planet.rotation_degrees = rot;
		planet.get_child(9).rotation_degrees = rot - 90;
		planet.get_child(10).rotation_degrees = rot + 90;
		add_child(planet);



###FONCTION DE LANCEMENT DES TEST###
func _on_Test_timeout():
	$Test.start();
	if (get_child_count() >= 5) && creatingLevel:
		firstCheck = true;
		if firstCheck:
			creatingLevel = false;
			firstCheck = false;
			emit_signal("doneCreatingLevel");
