extends KinematicBody2D
class_name Player

export(float) var WalkSpeed = 300.0
export(float) var WalkAcc = 8.0
export(float) var WalkFriction = 0.05

var Velocity = Vector2.ZERO
var WantedVelocity = Vector2.ZERO

onready var HandNode = $Hand
var HandSpringDistance : float

func _ready():
	HandSpringDistance = HandNode.position.length()
	
#
#	 if Input.is_mouse_button_pressed(1): # when click Left mouse button
#        target = get_global_mouse_position()
#    velocity = global_position.direction_to(target) * speed
#    if global_position.distance_to(target) > 5:
#        velocity = move_and_slide(velocity)
	
	
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
	Velocity = lerp(Velocity, WantedVelocity, WalkAcc * delta)
	
func _physics_process(delta):
	Velocity = move_and_slide(Velocity)
	Velocity = lerp(Velocity, Vector2.ZERO, WalkFriction)
