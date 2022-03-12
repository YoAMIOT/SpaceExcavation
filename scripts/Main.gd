extends Node2D

###FONCTION DE DETECTION DE FIN DE GENERATION DE NIVEAU###
func _on_PlanetSpawner_doneCreatingLevel():
	$EndGame.start();



###FONCTION DE GESTION DE FIN DE PARTIE###
func _on_EndGame_timeout():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/EndGame.tscn");
