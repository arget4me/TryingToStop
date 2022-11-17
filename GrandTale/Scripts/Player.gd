extends KinematicBody2D
class_name Player

onready var LabelParticle =  preload("res://Scenes/LabelParticle.tscn")

signal health_changed(health)
signal gold_changed(gold)
signal cooldown_changed(cooldown_percent)

export(int) var Health = 100
var MaxHealth = Health

var Gold = 0

export(float) var WalkSpeed = 320.0
export(float) var WalkAcc = 10.0
export(float) var WalkFriction = 0.1
export(float) var DashAmout = 1200.0
export(float) var DashCooldown = 1.2

var DashTimer = 0

var Velocity = Vector2.ZERO
var WantedVelocity = Vector2.ZERO

onready var HandNode = $Hand
var HandSpringDistance : float

onready var TempSprite = $ColorRect_TempSprite
onready var TempSpriteHand = $Hand/ColorRect_TempHand
var TempSpriteColor
var TempSpriteHandColor

func _ready():
	HandSpringDistance = HandNode.position.length()
	TempSpriteColor = TempSprite.color
	TempSpriteHandColor = TempSpriteHand.color
	
func _process(delta):
	
	var target = get_global_mouse_position()
	var dir = (target - global_position).normalized()
	HandNode.position = lerp(HandNode.position, dir * HandSpringDistance, 13.0 * delta)
	
	WantedVelocity = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		WantedVelocity += Vector2.UP
	if Input.is_action_pressed("ui_down"):
		WantedVelocity += Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		WantedVelocity += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		WantedVelocity += Vector2.RIGHT
	WantedVelocity = WantedVelocity.normalized() * WalkSpeed
	
	if DashTimer <= 0:
		if Input.is_mouse_button_pressed(1):
			Velocity += dir * DashAmout
			DashTimer = DashCooldown
			emit_signal("cooldown_changed", 1.0 - clamp(DashTimer/DashCooldown, 0.0, 1.0))
	else:
		DashTimer -= delta
		emit_signal("cooldown_changed", 1.0 - clamp(DashTimer/DashCooldown, 0.0, 1.0))
	
	Velocity = lerp(Velocity, WantedVelocity, WalkAcc * delta)


func GainGold(var Amount : int):
	Gold += Amount
	emit_signal("gold_changed", Gold)
	var particle = LabelParticle.instance()
	get_tree().get_root().add_child(particle)
	particle.StartSimulation(global_position + 20 * Vector2.UP, 2.0, 20, 30, 3.0, Color.yellow, "+" + str(Amount) + " Gold")
		

func UpdateHealthColor():
	var HealthRatio = 1 - clamp(float(Health) / float(MaxHealth - 50), 0.2, 1.0)
	TempSprite.color = lerp(TempSpriteColor, Color.red, HealthRatio)
	TempSpriteHand.color = lerp(TempSpriteHandColor, Color.red, HealthRatio)

func RecoverHealth(var Amount : int):
	Health = clamp(Health + Amount, 0, MaxHealth)
	emit_signal("health_changed", Health)
	var particle = LabelParticle.instance()
	get_tree().get_root().add_child(particle)
	particle.StartSimulation(global_position + 20 * Vector2.UP, 2.0, 20, 30, 3.0, Color.red, "+" + str(Amount))
	UpdateHealthColor()
	
func _physics_process(_delta):
	Velocity = move_and_slide(Velocity)
	Velocity = lerp(Velocity, Vector2.ZERO, WalkFriction)


func _on_Area2D_body_entered(body):
	if body is EnemyBase:
		Health -= body.DamagePerHit
		emit_signal("health_changed", Health)
		var particle = LabelParticle.instance()
		get_tree().get_root().add_child(particle)
		particle.StartSimulation(global_position + 20 * Vector2.UP, 2.0, 20, 30, 3.0, Color.red, "-" + str(body.DamagePerHit))
		UpdateHealthColor()
