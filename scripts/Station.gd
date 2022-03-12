extends StaticBody2D

func _on_PlayerModule_creatingLevel():
	self.visible = false;


func _on_PlayerModule_doneCreatingLevel():
	self.visible = true;
