extends Area2D

func _on_Item_body_entered(body):
	if body is Player:
		var player = body as Player
		player.RecoverHealth(5)
		queue_free()
