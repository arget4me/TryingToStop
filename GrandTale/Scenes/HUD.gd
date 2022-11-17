extends CanvasLayer

onready var health_bar = $Health/CurrentHealth
onready var health_label = $Health/Label
onready var health_container = $Health

onready var cooldown_bar = $Cooldown/CurrentCooldown
onready var cooldown_container = $Cooldown


var health_bar_width : int
var cooldown_bar_width : int

func _ready():
	health_bar_width = int(health_container.rect_size.x)
	health_label.text = String(health_bar_width / 100 * 100)

	cooldown_bar_width = int(cooldown_container.rect_size.x)


func _on_Player_health_changed(health):
	health_bar.rect_size.x = (health_bar_width / 100 * health) / 100 * health_bar_width
	health_label.text = String(health_bar_width / 100 * health)


func _on_Player_cooldown_changed(cooldown_percent):
	cooldown_bar.rect_size.x = cooldown_bar_width * cooldown_percent
