extends Node2D

const VU_COUNT = 1; #NOMBRE DE CELLULES
const FREQ_MAX = 11050.0; #FREQUENCE PLAFOND
const WIDTH = 10;
const HEIGHT = 100;
const MIN_DB = 30;

onready var Offset = self.transform.origin - get_parent().get_node("Player").transform.origin;

var spectrum;
var switched = false;
var highSound = preload("res://ressources/sound/High.wav");
var lowSound = preload("res://ressources/sound/Low.wav");
var ultraLowSound = preload("res://ressources/sound/UltraLow.wav");
var hBloup = preload("res://ressources/sound/HighBloup.wav");
var lBloup = preload("res://ressources/sound/LowBloup.wav");
var ulBloup = preload("res://ressources/sound/UltraLowBloup.wav")

func _draw():
	#warning-ignore:integer_division
	var w = WIDTH / VU_COUNT;
	var prev_hz = 0;
	if get_parent().get_node("Player").sensing == true: 
		if $Player.stream == hBloup || $Player.stream == lBloup:
			for i in range(1, VU_COUNT+1):
				var hz = i * FREQ_MAX / VU_COUNT;
				var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length();
				var energy = clamp((MIN_DB + linear2db(magnitude)) / MIN_DB, 0, 1);
				var height = energy * HEIGHT;
				draw_rect(Rect2(w * i, HEIGHT - height, w, height),  Color( 0.54, 0.17, 0.89, 1 ));
				prev_hz = hz;
		elif $Player.stream == ulBloup:
			for i in range(1, VU_COUNT+1):
				var hz = i * FREQ_MAX / VU_COUNT;
				var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length();
				var energy = clamp((MIN_DB + linear2db(magnitude)) / MIN_DB, 0, 1);
				var height = energy * HEIGHT;
				draw_rect(Rect2(w * i, HEIGHT - height, w, height),  Color( 0.54, 0.17, 0.89, 1 ));
				prev_hz = hz;
		elif $Player.stream == highSound || $Player.stream == lowSound:
			for i in range(1, VU_COUNT+1):
				var hz = i * FREQ_MAX / VU_COUNT;
				var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length();
				var energy = clamp((MIN_DB + linear2db(magnitude)) / MIN_DB, 0, 1);
				var height = energy * HEIGHT;
				draw_rect(Rect2(w * i, HEIGHT - height, w, height),  Color( 0, 1, 0, 1 ));
				prev_hz = hz;
		elif $Player.stream == ultraLowSound:
			for i in range(1, VU_COUNT+1):
				var hz = i * FREQ_MAX / VU_COUNT;
				var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length();
				var energy = clamp((MIN_DB + linear2db(magnitude)) / MIN_DB, 0, 1);
				var height = energy * HEIGHT;
				draw_rect(Rect2(w * i, HEIGHT - height, w, height),  Color( 0, 1, 0, 1 ));
				prev_hz = hz;
		else:
			for i in range(1, VU_COUNT+1):
				var hz = i * FREQ_MAX / VU_COUNT;
				draw_rect(Rect2(0, 0, 0, 0), Color( 0, 0, 0, 0 ) );
				prev_hz = hz;



func _process(_delta):
	self.transform.origin = (get_parent().get_node("Player").transform.origin + Offset) + Vector2(100,0);
	update();



func _ready():
	spectrum = AudioServer.get_bus_effect_instance(0,0);
