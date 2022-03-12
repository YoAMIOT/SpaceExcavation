extends StaticBody2D

###FONCTION DE DETECTION DE CONTACT AVEC UNE AREA###
func _on_nonSpawnableZone_area_entered(area):
	if area.is_in_group("nonSpawnable"):
		area.get_parent().queue_free();
