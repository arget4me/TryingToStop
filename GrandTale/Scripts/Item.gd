extends Area2D

func _on_Item_body_entered(body):
	if body is Player:
		queue_free()