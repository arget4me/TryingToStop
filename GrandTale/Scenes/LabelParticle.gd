extends Node2D

var GrowToScale : float
var StartingPosition : Vector2
var RaiseToPosition : Vector2
var FallToPosition : Vector2
var MaxLifetimeSec : float
var ElapsedTime = 0.0
var Started = false

onready var Text = $Label

func StartSimulation(var SpawnPos : Vector2, var MaxScale : float, var UpAmount : float, var FallAmount : float, var LifetimeSec : float, var LabelColor : Color, var ParticleText : String	):
	global_position = SpawnPos
	StartingPosition = SpawnPos
	RaiseToPosition = SpawnPos + Vector2.UP * UpAmount
	FallToPosition = RaiseToPosition + Vector2.DOWN * FallAmount
	GrowToScale = MaxScale
	scale = Vector2.ZERO
	ElapsedTime = 0.0
	MaxLifetimeSec = LifetimeSec
	Started = true
	Text.set("custom_colors/font_color", LabelColor)
	Text.text = ParticleText
	
func _process(delta):
	if not Started:
		return
	
	ElapsedTime += delta
	
	var TimeRatio = clamp(ElapsedTime / MaxLifetimeSec, 0.0, 1.0)
	var RaiseFraction = 0.1
	var RaiseTimeRatio = TimeRatio / RaiseFraction
	
	var FallFraction = 1.0 - RaiseFraction
	var FallTimeRatio = clamp((TimeRatio - RaiseFraction) / FallFraction, 0.0, 1.0)
	
	if RaiseTimeRatio <= 1.0:
		global_position = lerp(StartingPosition, RaiseToPosition, RaiseTimeRatio)
		scale = lerp(Vector2.ZERO, Vector2.ONE * GrowToScale, RaiseTimeRatio)
	else:
		global_position = lerp(RaiseToPosition, FallToPosition, FallTimeRatio)
		scale = lerp(Vector2.ONE * GrowToScale, Vector2.ONE * GrowToScale * 2 / 3, FallTimeRatio)
		modulate = lerp(Color.white, Color(1, 1, 1, 0), FallTimeRatio)
	
	if ElapsedTime > MaxLifetimeSec:
		queue_free()
