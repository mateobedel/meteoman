extends Button

var play_icon = preload("res://texture/play.png")
var restart_icon = preload("res://texture/restart.png")
var original_pos = Vector2.ZERO	

enum {PLAY, PAUSE}
var state = PAUSE

func _begin():
	Event.player_ready.connect(_on_player_ready)


func _on_button_down():
	Event.click.play()
	match state:
		PLAY: #Restart pressed
			state = PAUSE
			icon = play_icon
			Event.emit_signal("player_ready",original_pos)
			Event.emit_signal("restart_pressed")
		PAUSE: #Play pressed
			state = PLAY
			icon = restart_icon
			Event.emit_signal("play_pressed")
			
			
func _on_player_ready(pos):
	original_pos = pos
