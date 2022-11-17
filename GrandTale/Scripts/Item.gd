extends Area2D

func _on_Item_body_entered(body):
	if body is Player:
		var player = body as Player
		seed(body.global_position.x - body.global_position.y)
		player.GainGold(5 * (randi() % 3 + 1))
		queue_free()
