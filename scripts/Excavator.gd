extends RigidBody2D

export var speed = 3000;
var thrust = -1400;
var velocity = Vector2();
var drop = false;
var inField = false;

signal enterGravField;
signal exitGravField;
signal enterMaxField;
signal exitMaxField;
signal enterExpulsor;
signal exitExpulsor;
signal canSense;
signal cantSense;
signal inStationZone;
signal outStationZone;

###FONCTION D'APPLICATION DES FORCES###
# warning-ignore:unused_argument
func _integrate_forces(state):
	excavatorMovement();
	apply_central_impulse(velocity.rotated(rotation));



###FONCTION INPUT###
func excavatorMovement():
	var input = Vector2();

	if Input.is_action_pressed("right") && drop:
		if inField:
			$"Sprite".flip_h = true;
			velocity = Vector2(speed, thrust);
		else:
			velocity = Vector2(0, thrust);

	elif Input.is_action_pressed("left") && drop:
		if inField:
			$"Sprite".flip_h = false;
			velocity = Vector2(-speed, thrust);
		else:
			velocity = Vector2(0, thrust);
	else:
		velocity = Vector2(0, thrust);

	return input;



###FONCTION DE GESTION D'ENTREE EN BOX###
func _on_hitBox_area_entered(area):
	if area.is_in_group("maxGravBox"):
		emit_signal("enterMaxField");

	if area.is_in_group("gravbox"):
		emit_signal("enterGravField");
		inField = true;

	if area.is_in_group("expulsor"):
		emit_signal("enterExpulsor");
		thrust = 0;
		speed = 500;

	if area.is_in_group("noSensor"):
		emit_signal("cantSense");

	if area.is_in_group("dropZone"):
		emit_signal("inStationZone");



###FONCTION DE GESTION DE SORTIE DE BOX###
func _on_hitBox_area_exited(area):
	if area.is_in_group("maxGravBox"):
		emit_signal("exitMaxField");

	if area.is_in_group("gravbox"):
		emit_signal("exitGravField");
		inField = false;

	if area.is_in_group("expulsor"):
		emit_signal("exitExpulsor");
		thrust = -1400;
		speed = 3000;

	if area.is_in_group("noSensor"):
		emit_signal("canSense");

	if area.is_in_group("dropZone"):
		emit_signal("outStationZone");



###FONCTION DE GESTION DU DROPMODE###
func _on_Player_dropOn(dropMode):
	if dropMode == true:
		self.mode = MODE_RIGID;

	elif dropMode == false:
		self.mode = MODE_STATIC;
	drop = dropMode;
