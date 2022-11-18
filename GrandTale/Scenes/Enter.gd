extends Area2D

export(Resource) var TravelToScene

func _on_Enter_body_entered(body):
	if body is Player:
		get_tree().change_scene(TravelToScene.get_path())
