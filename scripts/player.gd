extends RigidBody2D

const SPEED = 65000;
const ROTATION_SPEED = 90000000;

var velocity = Vector2();
var rotationDir = 0;
var inField = false;
var dropMode = false;
var mergePos = Vector2();
var excaPos = Vector2();
var boost = 90000;
var inExpulsor = false;
var canDrop = false;
var canShoot = false;
var shooting = false;
var dead = false;
var creatingLevel = false;
var previousLinearVel;
var highSound = preload("res://ressources/sound/High.wav");
var lowSound = preload("res://ressources/sound/Low.wav");
var ultraLowSound = preload("res://ressources/sound/UltraLow.wav");
var hBloup = preload("res://ressources/sound/HighBloup.wav");
var lBloup = preload("res://ressources/sound/LowBloup.wav");
var ulBloup = preload("res://ressources/sound/UltraLowBloup.wav");
var stopSound = false;
var speed;
var canSense = false;
var canUnload = true;
var unloadMode = true;
var ressources = 0;
var energium = 0;

export var health = 100;
export (PackedScene) var Bullet;
export var sensing = false;

signal dropOn(dropMode);

###FONCTION DE PROCESS###
# warning-ignore:unused_argument
func _physics_process(delta):
	if !dropMode:
		mergePos = get_node("MergePos").global_position;
		get_parent().get_node("Excavator").global_position = mergePos;
		get_parent().get_node("Excavator").rotation_degrees = rotation_degrees;
		emit_signal("dropOn", dropMode);

	if dropMode:
		if get_parent().get_node("Excavator").global_position < (get_node("MergePos").global_position + Vector2(20, 20)) && get_parent().get_node("Excavator").global_position > (get_node("MergePos").global_position + Vector2(-20, -20)):
			get_parent().get_node("Excavator").speed = 1800;
		else:
			get_parent().get_node("Excavator").speed = 3000;
		sensing = false;
		stopSound = true;

	set_applied_force(velocity.rotated(rotation));
	set_applied_torque(rotationDir * ROTATION_SPEED);
	speed = int(get_linear_velocity().length());



# warning-ignore:unused_argument
func _process(delta):
	spaceshipMovement();
	animator();
	get_parent().get_node("HealthBar/Health").value = health;
	if stopSound:
		get_parent().get_node("Spectrum/Player").stop();


###FONCTION INPUT###
func spaceshipMovement():
	var input = Vector2();

	if !dead && !creatingLevel:
		if Input.is_action_pressed("up") && !dropMode:
			velocity = Vector2(0, -SPEED);
			if Input.is_action_pressed("boost") && !dropMode:
				velocity = Vector2(0, -boost);
		elif Input.is_action_pressed("down") && !dropMode:
				velocity = Vector2(0, SPEED);
		else:
			velocity = Vector2(0, 0);

		rotationDir = 0;

		if Input.is_action_pressed("right") && !dropMode:
			rotationDir += 1;
		if Input.is_action_pressed("left") && !dropMode:
			rotationDir -= 1;

		if Input.is_action_just_pressed("dropMode"):
			if canDrop:
				droping();
			elif canUnload:
				unload();

		if Input.is_action_just_pressed("shoot") && !dropMode:
			if canShoot:
				shoot();

		if Input.is_action_just_pressed("sensor") && !dropMode:
			if canSense:
				sensor();
	return input;



###FONCTION DE GESTION DU DROPMODE###
func droping():
	if !dropMode:
		dropMode = true;
		get_node("Camera2D").current = false;
		get_parent().get_node("Excavator/Camera2D").current = true;
		get_parent().get_node("HealthBar").visible = false;
		get_parent().get_node("Speed").visible = false;
		get_parent().get_node("RessourcesCount").visible = false;
		get_parent().get_node("EnergiumCount").visible = false;
		self.mode = MODE_STATIC

	elif dropMode:
		if get_parent().get_node("Excavator").global_position < (get_node("MergePos").global_position + Vector2(7, 7)) && get_parent().get_node("Excavator").global_position > (get_node("MergePos").global_position + Vector2(-7, -7)):
			dropMode = false;
			get_parent().get_node("Excavator/Camera2D").current = false;
			get_node("Camera2D").current = true;
			get_parent().get_node("HealthBar").visible = true;
			get_parent().get_node("Speed").visible = true;
			get_parent().get_node("RessourcesCount").visible = true;
			get_parent().get_node("EnergiumCount").visible = true;
			self.mode = MODE_RIGID
	emit_signal("dropOn", dropMode);



###FONCTION DE GESTION DU SENSOR DE PLANETE###
func sensor():
	if !sensing:
		sensing = true;
		get_parent().get_node("Spectrum").visible = true;

	elif sensing:
		sensing = false;
		stopSound = true;
		get_parent().get_node("Spectrum").visible = false;
		get_parent().get_node("Spectrum/Player").stop();



func unload():
	if unloadMode:
		unloadMode = false;
		self.mode = MODE_RIGID;
		health = 100;

	elif !unloadMode:
		unloadMode = true;
		if ressources >= 10:
			energium += int(ressources / 10);
			ressources = 0;
		self.global_position = get_parent().get_node("Station/unloadPos").global_position;
		self.rotation = get_parent().get_node("Station/unloadPos").rotation;
		self.mode = MODE_STATIC


###FONCTION DE GESTION D'ENTREE EN CHAMP GRAVITATIONNEL###
func _on_Excavator_enterGravField():
	inField = true;
	canSense = false
	sensing = false;
	stopSound = true;
	get_parent().get_node("Spectrum").visible = false;
	get_parent().get_node("Spectrum/Player").stop();



###FONCTION DE GESTION DE SORTIE DE CHAMP GRAVITATIONNEL###
func _on_Excavator_exitGravField():
	inField = false;
	canSense = true;



###FONCTION DE GESTION D'ENTREE EN CHAMP GRAVITATIONNEL MAX###
func _on_Excavator_enterMaxField():
	boost = 175000;



###FONCTION DE GESTION DE SORTIE DE CHAMP GRAVITATIONNEL MAX###
func _on_Excavator_exitMaxField():
	boost = 100000;



###FONCTION D'ENTREE EN EXPLUSEUR###
func _on_Excavator_enterExpulsor():
	inExpulsor = true;
	
	if inField:
		if !inExpulsor:
			canDrop = true;
		else:
			canDrop = false;



###FONCTION DE SORTIE D'EXPULSEUR###
func _on_Excavator_exitExpulsor():
	inExpulsor = false;
	
	if inField:
		if !inExpulsor:
			canDrop = true;
		else:
			canDrop = false;



###FONCTION DE TIR###
func shoot():
	shooting = true;
	canShoot = false;
	$Cooldown.start();

	var RBullet = Bullet.instance();
	owner.add_child(RBullet);
	RBullet.transform = $Gun/RGunPos.global_transform;

	var LBullet = Bullet.instance();
	owner.add_child(LBullet);
	LBullet.transform = $Gun/LGunPos.global_transform;



###DETECTION DE FIN DE COOLDOWN###
func _on_Cooldown_timeout():
	shooting = false;
	canShoot = true;



###ANIMATEUR###
func animator():
	if dead:
		$Ship.play("dead");
	elif dropMode:
		$Ship.play("onPlanet");
	elif !dropMode:
		if !shooting:
			$Ship.play("normal");
		elif shooting:
			$Ship.play("shooting");



###FONCTION DE GESTION DE LA MORT TEMPORAIRE###
func tempDeath():
	dead = true;
	ressources -= int(ressources / 3);
	velocity = Vector2(0, 0);
	rotationDir = 0;
	$DeathCooldown.start();
	sensing = false;
	stopSound = true;
	if energium >= 1: 
		energium -= 1;
	get_parent().get_node("HealthBar").visible = false;
	get_parent().get_node("Speed").visible = false;
	get_parent().get_node("Spectrum").visible = false;
	get_parent().get_node("RessourcesCount").visible = false;
	get_parent().get_node("EnergiumCount").visible = false;



###FONCTION DE GESTION DU RESPAWN###
func _on_DeathCooldown_timeout():
	health = 33;
	dead = false;
	get_parent().get_node("HealthBar").visible = true;
	get_parent().get_node("Speed").visible = true;
	get_parent().get_node("RessourcesCount").visible = true;
	get_parent().get_node("EnergiumCount").visible = true;



###FONCTION DE DETECTION DE CREATION DU NIVEAU###
func _on_PlayerModule_creatingLevel():
	creatingLevel = true;
	self.gravity_scale = 0;
	self.rotation = 0;
	$LoadingScreen.visible = true;
	get_parent().get_node("Speed").visible = false;
	get_parent().get_node("RessourcesCount").visible = false;
	get_parent().get_node("EnergiumCount").visible = false;



###FONCTION DE DETECTION DE FIN DE CREATION DU NIVEAU###
func _on_PlayerModule_doneCreatingLevel():
	creatingLevel = false;
	self.gravity_scale = 1;
	health = 100;
	canDrop = false;
	$Collision.disabled = false;
	get_parent().get_node("Speed").visible = true;
	get_parent().get_node("RessourcesCount").visible = true;
	get_parent().get_node("EnergiumCount").visible = true;
	canSense = false;
	$LoadingScreen.visible = false;
	$Timer.start();



###FONCTION DE DETECTION DE CONTACT AVEC UN BODY###
func _on_hitBox_body_entered(body):
	if body.is_in_group("Asteroid"):
		var asteroidSpeed = int(body.get_linear_velocity().length());

		var contactSpeedTotal = int((asteroidSpeed + speed));

		if contactSpeedTotal < 0:
			contactSpeedTotal = contactSpeedTotal * -1;

		health -= contactSpeedTotal / 20;

	if body.is_in_group("Planet"):
		if speed > 60:
			health -= speed / 7;

	if body.is_in_group("Station"):
		if speed > 60:
			health -= speed / 7;

	if health <= 0 && dead == false:
		tempDeath();



###FONCTION DE DETECTION ULTRA-LARGE EN ENTREE DE ZONE###
func _on_LargestSensor_area_entered(area):
	if sensing:
		stopSound = true;
		stopSound = false;
		if area.is_in_group("maxGravBox"):
			get_parent().get_node("Spectrum/Player").set_stream(ultraLowSound);
			get_parent().get_node("Spectrum/Player").play();
		if area.is_in_group("noSensor"):
			get_parent().get_node("Spectrum/Player").set_stream(ulBloup);
			get_parent().get_node("Spectrum/Player").play();



###FONCTION DE DETECTION LARGE EN ENTREE DE ZONE###
func _on_LargeSensor_area_entered(area):
	if sensing:
		stopSound = true;
		stopSound = false;
		if area.is_in_group("maxGravBox"):
			get_parent().get_node("Spectrum/Player").set_stream(lowSound);
			get_parent().get_node("Spectrum/Player").play();
		if area.is_in_group("noSensor"):
			get_parent().get_node("Spectrum/Player").set_stream(lBloup);
			get_parent().get_node("Spectrum/Player").play();



###FONCTION DE DETECTION FINE EN ENTREE DE ZONE###
func _on_ThinSensor_body_entered(body):
	if sensing:
		stopSound = true;
		stopSound = false;
		if body.is_in_group("Planet"):
			get_parent().get_node("Spectrum/Player").set_stream(highSound);
			get_parent().get_node("Spectrum/Player").play();
		if body.is_in_group("Station"):
			get_parent().get_node("Spectrum/Player").set_stream(hBloup);
			get_parent().get_node("Spectrum/Player").play();


###FONCTION DE DETECTION ULTRA-LARGE EN SORTIE DE ZONE###
func _on_LargestSensor_area_exited(area):
	if sensing:
		if area.is_in_group("maxGravBox"):
			stopSound = true;
		if area.is_in_group("noSensor"):
			stopSound = true;



###FONCTION DE DETECTION LARGE EN SORTIE DE ZONE###
# warning-ignore:unused_argument
func _on_LargeSensor_area_exited(area):
	if sensing:
		if area.is_in_group("maxGravBox"):
			stopSound = true;
		if area.is_in_group("noSensor"):
			stopSound = true;



###FONCTION DE DETECTION FINE EN SORTIE DE ZONE###
# warning-ignore:unused_argument
func _on_ThinSensor_body_exited(body):
	if sensing:
		if body.is_in_group("Planet"):
			stopSound = true;
		if body.is_in_group("Station"):
			stopSound = true;



###FONCTION DE GESTION D'ACTIVATION DU SENSOR###
func _on_Excavator_canSense():
	get_parent().get_node("HealthBar").visible = true;



###FONCTION DE GESTION DE DESACTIVATION DU SENSOR###
func _on_Excavator_cantSense():
	get_parent().get_node("HealthBar").visible = false;
	get_parent().get_node("Spectrum").visible = false;
	get_parent().get_node("Spectrum/Player").stop();



###FONCTIONS DE GESTION DE DECHARGEMENT
func _on_Excavator_inStationZone():
	canUnload = true;
	canSense = false;
	sensing = false;
	canShoot = false

func _on_Excavator_outStationZone():
	canUnload = false;
	canSense = true;
	canShoot = true;
	unloadMode = false;



###FIN DE VERIF DE GENERATION DE NIVEAU###
func _on_Timer_timeout():
	if !creatingLevel:
		$LoadingScreen.visible = false;
		$LoadingScreen.queue_free();
		$Timer.queue_free();
