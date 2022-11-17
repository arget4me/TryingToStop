extends EnemyBase
class_name Enemy

export(float) var DamagePerHit = 10.0

export(float) var WalkSpeed = 300.0
export(float) var WalkAcc = 8.0
export(float) var WalkFriction = 0.05

var Velocity = Vector2.ZERO
var PlayerDir = Vector2.ZERO
var Player: Node

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		Player = body

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		Player = null
		PlayerDir = Vector2.ZERO

func _process(delta):
	if Player != null:
		PlayerDir = (Player.global_position - global_position).normalized()
	Velocity = lerp(Velocity, PlayerDir * WalkSpeed, WalkAcc * delta)

func _physics_process(_delta):
	Velocity = move_and_slide(Velocity)
	Velocity = lerp(Velocity, Vector2.ZERO, WalkFriction)


