extends CanvasLayer

onready var health_bar = $Health/CurrentHealth
onready var health_label = $Health/Label
onready var health_container = $Health

var health_bar_width

func _ready():
	health_bar_width = int(health_container.rect_size.x)
	health_label.text = String(health_bar_width / 100 * 100)



func _on_Player_health_changed(health):
	health_bar.rect_size.x = (health_bar_width / 100 * health) / 100 * health_bar_width
	health_label.text = String(health_bar_width / 100 * health)
