extends Control

@onready var rain = preload("res://texture/rain.png")
@onready var rain2 = preload("res://texture/rain2.png")
@onready var wind = preload("res://texture/vent.png")
@onready var wind2 = preload("res://texture/vent2.png")

func _ready():
	Camera.set_process(false)
	$Timer.start(1.0/3)
	Event.transition_in_done.connect(on_transition_in_done)
	if !Event.theme.playing:
		Event.theme.play()
	


func _on_play_pressed():
	Camera.set_process(true)
	Event.theme.stop()
	Event.start = true
	Event.emit_signal("trans_start")
	Event.click.play()

func _on_how_pressed():
	get_tree().change_scene_to_file("res://scenes/how.tscn")
	Event.click.play()

func on_transition_in_done():
	get_tree().change_scene_to_file("res://worlds/level1.tscn")


func _on_timer_timeout():
	match $bg.texture:
		rain2:
			$bg.texture = rain
		rain:
			$bg.texture = wind2
		wind2:
			$bg.texture = wind
		wind:
			$bg.texture = rain2
	$Timer.start(1.0/3)
