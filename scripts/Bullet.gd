extends Area2D

var speed = 750;
var inField = false;

###FONCTION DE PROCESS###
func _physics_process(delta):
	position += transform.x * speed * delta;
	if inField:
		$".".scale.x = 1;
		$".".scale.y = 1;
		speed = 1500;
	else:
		$".".scale.x = 2;
		$".".scale.y = 2;
		speed = 750;



###FONCTION DE DETECTION DE CONTACT AVEC UN BODY###
func _on_Bullet_body_entered(body):
	if body.is_in_group("player"):
		body.health += -10;
		if body.health <= 0 && body.dead == false:
			body.tempDeath();
	if body.is_in_group("Asteroid"):
		get_parent().get_child(1).ressources += 5;
		body.queue_free();
	queue_free();



###FONCTION DE DETECTION DE CONTACT AVEC UNE AREA###
func _on_Bullet_area_entered(area):
	if area.is_in_group("gravbox"):
		$Sprite.play("OnPlanet");
		inField = true;
	if area.is_in_group("KillerEdge"):
		queue_free();



###FONCTION DE DETECTION DE SORTIE D'AREA###
func _on_Bullet_area_exited(area):
	if area.is_in_group("gravbox"):
		$Sprite.play("InSpace");
		inField = false;
